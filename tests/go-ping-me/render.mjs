#!/usr/bin/env node
// ABOUTME: Exercise Go Ping Me's public authoring contract through isolated Hugo builds.
// ABOUTME: Inspect generated HTML locally without provider requests or email submission.
import assert from 'node:assert/strict';
import {mkdtempSync, mkdirSync, writeFileSync, readFileSync, rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {resolve, dirname, join} from 'node:path';
import {fileURLToPath} from 'node:url';
import {spawnSync} from 'node:child_process';
const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const temporary = mkdtempSync(join(tmpdir(), 'folio-gpm-'));
let count = 0;
const settings = () => ({service_origin: 'https://forms.example.test/', helper_path: 'contact-helper.js', turnstile: {enabled: false}, forms: {contact: {schema: 'contact', enhanced: true}, native: {schema: 'contact', enhanced: false}}});
function build(config, content, failure) {
  const source = join(temporary, `site-${++count}`);
  mkdirSync(join(source, 'content'), {recursive: true});
  writeFileSync(join(source, 'hugo.json'), JSON.stringify({baseURL: 'https://site.example.test/', title: 'Fixture', params: {go_ping_me: config}, markup: {goldmark: {renderer: {unsafe: true}}}}));
  writeFileSync(join(source, 'content/form.md'), `---\ntitle: Form\n---\n${content}\n`);
  const result = spawnSync('hugo', ['--source', source, '--destination', join(source, 'public'), '--themesDir', dirname(root), '--theme', root.split('/').at(-1), '--cacheDir', join(temporary, 'cache'), '--noBuildLock'], {encoding: 'utf8', timeout: 30000, env: {...process.env, GOCACHE: join(temporary, 'go-cache'), GOPATH: join(temporary, 'go'), HUGO_CACHEDIR: join(temporary, 'cache')}});
  if (failure) {
    assert.notEqual(result.status, 0, `Expected rejection: ${failure}`);
    assert.match(result.stderr + result.stdout, /form.md/, 'Error identifies source page');
    assert.match(result.stderr + result.stdout, failure);
    return;
  }
  assert.equal(result.status, 0, result.stderr + result.stdout);
  return readFileSync(join(source, 'public/form/index.html'), 'utf8');
}
function query(html, selector, attribute) {
  const args = attribute ? ['--attribute', attribute, selector] : [selector];
  const result = spawnSync('htmlq', args, {input: html, encoding: 'utf8', timeout: 10000});
  assert.equal(result.status, 0, result.stderr);
  return result.stdout.trim();
}
try {
  const single = build(settings(), '{{< go-ping-me form="contact" />}}');
  assert.equal(query(single, 'form.go-ping-me', 'action'), 'https://forms.example.test/');

  assert.equal(query(single, 'form', 'method'), 'post');
  assert.equal(query(single, 'form', 'enctype'), 'application/x-www-form-urlencoded');
  assert.equal(query(single, 'input[name=schema]', 'value'), 'contact');
  assert.equal(query(single, 'input[required], textarea[required]', 'name').split('\n').sort().join(','), 'email,message,name');
  assert.equal(query(single, 'input[name=subject][required]'), '');
  assert.equal(query(single, 'input[name=name]', 'autocomplete'), 'name');
  assert.equal(query(single, 'input[name=email]', 'autocomplete'), 'email');
  assert.equal(query(single, 'input[name=email]', 'type'), 'email');
  assert.equal(query(single, '[data-go-ping-me-status]', 'role'), 'status');
  assert.equal(query(single, '[data-go-ping-me-status]', 'aria-live'), 'polite');
  assert.equal(query(single, 'script[src$="contact-helper.js"]', 'src'), 'https://forms.example.test/contact-helper.js');
  assert.equal(query(single, '.cf-turnstile, [name=cf-turnstile-response], script[src*=challenges]'), '');
  const controls = '{{< go-ping-me-field name="company" type="text" label="Company" autocomplete="organization" >}}\n{{< go-ping-me-field name="interest" type="checkbox" label="Writing" value="writing" >}}\n{{< go-ping-me-field name="interest" type="checkbox" label="Technology" value="technology" >}}';
  const paired = '{{< go-ping-me form="contact" >}}\n' + controls + '\n{{< /go-ping-me >}}';
  const enabled = settings();
  enabled.turnstile = {enabled: true, site_key: 'PUBLIC_TEST_KEY'};
  const multiple = build(enabled, paired + '\n{{< go-ping-me form="native" />}}\n{{< go-ping-me form="contact" />}}');
  assert.equal(query(multiple, 'form.go-ping-me', 'id').split('\n').length, 3);
  assert.equal(query(multiple, 'form[data-go-ping-me]', 'id').split('\n').length, 2);
  assert.equal(query(multiple, '.cf-turnstile', 'data-sitekey'), ['PUBLIC_TEST_KEY','PUBLIC_TEST_KEY','PUBLIC_TEST_KEY'].join('\n'));
  assert.equal(query(multiple, '.cf-turnstile[data-action]'), '');
  assert.equal(query(multiple, 'script[src*=challenges]', 'src').split('\n').length, 1);
  assert.equal(query(multiple, 'script[src$="contact-helper.js"]', 'src').split('\n').length, 1);
  assert.ok(query(multiple, 'script[src$="contact-helper.js"][defer]'));
  assert.equal(query(multiple, 'form input[name=interest]', 'value'), 'writing\ntechnology');
  assert.equal(query(multiple, 'form input[name=company]', 'autocomplete'), 'organization');
  const ids = query(multiple, 'form [id], form[id]', 'id').split('\n');
  assert.equal(new Set(ids).size, ids.length);
  const labels = query(multiple, 'form label', 'for').split('\n');
  assert.equal(new Set(labels).size, labels.length);
  for (const id of labels) assert.ok(ids.includes(id), 'label targets existing unique control');
  const native = build(settings(), '{{< go-ping-me form="native" />}}');
  assert.equal(query(native, '[data-go-ping-me-status], script[src$="contact-helper.js"], .cf-turnstile'), '');
  assert.equal(query(native, 'form button[type=submit]').split('</button>').length - 1, 1);
  const other = settings();
  other.service_origin = 'https://other.example.test:443/';
  other.turnstile = {enabled: true, site_key: 'OTHER_KEY'};
  const isolated = build(other, '{{< go-ping-me form="contact" />}}');
  assert.equal(query(isolated, 'form', 'action'), other.service_origin);
  assert.equal(query(isolated, '.cf-turnstile', 'data-sitekey'), 'OTHER_KEY');
  assert.equal(query(isolated, '.cf-turnstile[data-action]'), '');
  assert.equal(query(isolated, 'script[src$="contact-helper.js"]', 'src'), other.service_origin + 'contact-helper.js');
  assert.ok(!isolated.includes('PUBLIC_TEST_KEY'));
  assert.ok(!multiple.includes('OTHER_KEY'));
  const invocation = '{{< go-ping-me form="contact" />}}';
  for (const origin of ['http://forms.test/', 'https://forms.test', 'https://user@forms.test/', 'https://forms.test:8443/', 'https://forms.test/path/', 'https://forms.test/?x', 'https://forms.test/#x', '//forms.test/', 42]) {
    const config = settings(); config.service_origin = origin;
    build(config, invocation, /service_origin/);
  }
  for (const path of ['//evil.test/helper.js', '../contact-helper.js', 'https://evil.test/helper.js', '', 1]) {
    const config = settings(); config.helper_path = path;
    build(config, invocation, /helper_path/);
  }
  for (const mutate of [
    c => {c.turnstile.enabled = 'false';},
    c => {delete c.turnstile.enabled;},
    c => {c.turnstile.site_key = 'unused';},
    c => {c.turnstile.action = 'unused';},
    c => {c.turnstile = {enabled: true};},
    c => {c.turnstile.secret = 'forbidden';},
    c => {c.forms.contact.enhanced = 'true';},
    c => {delete c.forms.contact.enhanced;},
    c => {c.forms.contact.schema = 'unknown';},
    c => {c.forms.contact.action = 'unsupported';},
    c => {c.forms.contact.recipient = 'no@example.test';},
    c => {c.recipient = 'no@example.test';},
    c => {c.forms = {};},
    c => {c.forms = [];},
    c => {c.turnstile = [];},
    c => {c.forms.contact = 'contact';},
  ]) {
    const config = settings(); mutate(config); build(config, invocation, /go-ping-me/);
  }
  build(settings(), '{{< go-ping-me />}}', /missing or unknown form/);
  build(settings(), '{{< go-ping-me form="missing" />}}', /missing or unknown form/);
  build(settings(), '{{< go-ping-me form="contact" recipient="x" />}}', /only the named form/);
  const wrap = content => '{{< go-ping-me form="contact" >}}' + content + '{{< /go-ping-me >}}';
  for (const content of ['<input name="recipient">', 'arbitrary text', '{{< rawhtml >}}<b>raw</b>{{< /rawhtml >}}']) build(settings(), wrap(content), /raw inner/);
  for (const name of ['schema','SCHEMA','cf-turnstile-response','recipient','recipients','to','from','cc','bcc','sender','headers','action','success_url','failure_url','redirect','NAME','email','subject','message','bad[]','9bad','x'.repeat(65)]) {
    build(settings(), wrap('{{< go-ping-me-field name="' + name + '" label="Field" >}}'), /invalid or protected/);
  }
  for (const type of ['file','hidden','submit','object','button']) build(settings(), wrap('{{< go-ping-me-field name="extra" label="Field" type="' + type + '" >}}'), /unsupported control/);
  build(settings(), wrap('{{< go-ping-me-field name="extra" >}}'), /visible label/);
  build(settings(), wrap('{{< go-ping-me-field name="extra" label="Field" onclick="bad" >}}'), /unknown field attribute/);
  build(settings(), wrap('{{< go-ping-me-field name="extra" label="Field" required="maybe" >}}'), /required must/);
  build(settings(), wrap('{{< go-ping-me-field name="extra" label="Field" >}}'.repeat(2)), /duplicate field/);
  build(settings(), wrap(Array.from({length: 17}, (_, i) => '{{< go-ping-me-field name="interest" type="checkbox" label="Choice" value="v' + i + '" >}}').join('\n')), /exceeds 16/);
  build(settings(), wrap(Array.from({length: 28}, (_, i) => '{{< go-ping-me-field name="field' + i + '" label="Field" >}}').join('\n')), /exceeds 32/);
  build(settings(), '{{< go-ping-me-field name="extra" label="Field" >}}', /requires a go-ping-me parent/);
  build(settings(), wrap('{{< go-ping-me-field name="interest" type="checkbox" label="Choice" value="' + 'x'.repeat(2001) + '" >}}'), /checkbox value/);
  build(settings(), wrap('{{< go-ping-me-field name="interest" type="checkbox" label="Choice" value="same" >}}'.repeat(2)), /duplicate field/);
  const escaped = build(settings(), wrap('{{< go-ping-me-field name="company" label="<script>bad</script>" >}}'));
  assert.equal(query(escaped, 'form script'), '');
  assert.ok(query(escaped, 'form label').includes('&lt;script&gt;'));
  console.log('PASS ' + count + ' isolated Hugo builds: native/enhanced, multiple instances, independent sites and rejected declarations');
} finally {
  rmSync(temporary, {recursive: true, force: true});
}
