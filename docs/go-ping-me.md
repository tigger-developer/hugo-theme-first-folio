# Go Ping Me forms

The `go-ping-me` shortcode renders a named form using Go Ping Me's form
integration contract version 1. The service owns validation, origin authorization,
Turnstile verification, redirects, recipients and mail. The theme owns accessible
HTML and the hooks for the optional service-owned helper. The existing
`contactform` and `formspree` shortcodes are unchanged.

## Configuration

Each website owns one configuration block. These example values are not theme
defaults:

```yaml
params:
  go_ping_me:
    service_origin: https://forms.example.net/
    helper_path: contact-helper.js
    turnstile:
      enabled: false
    forms:
      general-enquiry:
        schema: contact
        enhanced: true
        action: general-enquiry
      project-enquiry:
        schema: contact
        enhanced: false
        action: project-enquiry
```

The service origin must be an absolute HTTPS root URL with a trailing slash,
without credentials, query, fragment or a non-default port. Explicit port 443
is accepted. Every form posts to that exact URL. The helper path must equal
`contact-helper.js`; it is required when any configured form is enhanced.

`forms` must be a non-empty map. Each entry requires `schema`, a strict boolean
`enhanced`, and its own non-blank `action`. The action remains part of the form's
service policy when Turnstile is disabled; when Turnstile is enabled, the same
value is also rendered into that form's widget. Only the published `contact`
schema is currently supported. Unknown
schemas and configuration keys fail the build with the source page identified.
The service's current published contract does not yet define `customform`.
Schema definitions live separately from the shared renderer, so another published
schema can use the same public shortcode without duplicating form machinery.

For Turnstile, replace the disabled block with:

```yaml
turnstile:
  enabled: true
  site_key: PUBLIC_SITE_KEY
```

`enabled` must be a boolean. The public key is required when enabled and forbidden
when disabled. The action belongs to each named form, so forms on one website can
use different actions while sharing the site's public key.
The receiving service endpoint must recognize this public key and authorize the
website's exact origin and action. No secret belongs in Hugo configuration.

## Standard and extended forms

Hugo requires a shortcode that supports children to be paired or self-closed.
Use the trailing slash for a standard form:

```go-html-template
{{< go-ping-me form="general-enquiry" />}}
```

The contact schema renders required name, email and message controls and an
optional subject. A blank subject is left for the service to default.

To add controls, use paired syntax and direct child field shortcodes:

```go-html-template
{{< go-ping-me form="general-enquiry" >}}
  {{< go-ping-me-field name="company" type="text" label="Company" autocomplete="organization" >}}
  {{< go-ping-me-field name="interest" type="checkbox" label="Writing" value="writing" >}}
  {{< go-ping-me-field name="interest" type="checkbox" label="Technology" value="technology" >}}
{{< /go-ping-me >}}
```

Raw inner HTML and text are rejected. Fields accept only `name`, `type`, `label`,
`autocomplete`, `required` and `value`. Supported types are `text` (default),
`email`, `tel`, `url`, `textarea` and `checkbox`. A visible non-blank label is
required. `required` accepts `true` or `false`; only checkboxes accept `value`,
which is required and non-blank. Autocomplete is allowed for non-checkbox fields.
Labels and values are escaped rather than treated as HTML.

Additional names match `[A-Za-z][A-Za-z0-9_.-]{0,63}`. They cannot duplicate
built-in contact fields or protected metadata, including case variants:

```text
schema cf-turnstile-response recipient recipients to from cc bcc sender
headers action success_url failure_url redirect name email subject message
```

Only checkboxes may repeat an exact name, with distinct values and at most 16
controls. Other duplicate names are rejected. Each checkbox value has at most
2,000 Unicode code points and excludes control characters other than newline
and tab. Forms allow at most 32 distinct submitted names, counting built-in
fields and the Turnstile token where enabled. File uploads, nested forms,
submission overrides, hidden metadata and extra submit controls are not exposed.

Native `maxlength` attributes assist entry. Browser length semantics are not the
service's byte or Unicode-code-point validation: the service remains authoritative
for all submitted values, including the 32 KiB encoded body limit, 254-byte email,
10,000-byte normalized message and 2,000-code-point additional values. There is
no competing theme submit listener.

## Multiple forms and enhancement

Named forms can be mixed or repeated on the same page. Each instance gets unique
IDs and associated labels. Enhanced forms contain one status region and one
submit button. Native forms remain usable without the helper. The helper and
Turnstile provider scripts each load once per page when needed.

The service helper owns duplicate prevention, the 15-second timeout, success
and failure text, submit-button recovery and form-local Turnstile reset.
Turnstile-disabled native forms work without JavaScript. Turnstile-enabled native
forms still require JavaScript to obtain a token.

## Content Security Policy

Add the service origin to `form-action`; enhanced forms also need it in
`connect-src` and `script-src`. Turnstile needs
`https://challenges.cloudflare.com` in `script-src` and `frame-src`. Review
[Cloudflare's current CSP guidance](https://developers.cloudflare.com/turnstile/reference/content-security-policy/)
for the consuming site's policy. The theme does not replace the site's CSP.
Infrastructure and the service own cross-origin policy; the theme does not
configure CORS or claim that another origin is authorized.

## Example site and migration

`exampleSite/content/contact/` demonstrates enhanced and native named forms and
additional checkbox fields. Its default configuration uses an invalid example
domain and disables Turnstile for local inspection. The `kepler452` environment
contains the operator-supplied public settings for the temporary live demo at
`https://demo.theme.tadg.ie/contact/`. These settings require service-side and
Turnstile hostname authorization before a real submission can succeed.

The native result pages are `/contact/thanks/` and `/contact/error/`. They do not
interpret query parameters. Redirect targets remain service-owned configuration.

Migration is deliberate: add `params.go_ping_me`, replace the selected old
invocation, and configure service policy outside the theme. Existing shortcodes
are not migrated automatically.

After the operator verifies native/enhanced submission, recovery and exactly the
expected email, set `draft: true` on the demonstration form page and rebuild the
live site. Keep the source example and result pages. Do not disable the page
before that acceptance evidence exists.

## Verification

Run `./tests/go-ping-me/render.mjs` for isolated local Hugo builds and HTML
assertions, or `make test` for those checks plus the existing regression suite.
Tests never contact Turnstile, the mail service or a hosted model. They cover
native and enhanced output, multiple named/repeated forms, independent site
configuration, field restrictions and malformed configuration.

Real browser verification and received-email acceptance are separate operator
checks, not outcomes established by the local tests.

## Recorded local evidence, 2026-11-08

The focused suite passed 76 isolated Hugo builds. The `kepler452` example build
produced 138 pages, and htmltest passed across 126 HTML documents. Inspection
confirmed two forms posting to the configured root, with one helper and one
Turnstile script. The original `contactform` and `formspree` files have no diff.

The full regression run reported 292 passes and three failures: RT-82.1
(homepage tag-cloud placement), RT-76.1 (inline spoiler pipeline), and RT-65.1
(theme portal metadata). An isolated archive of the unchanged HEAD reproduced
all three with the same totals. These are not reported as passing; the spoiler
failure includes a broken-pipe diagnostic.

A bounded helper request and preflight for the demo origin could not resolve
`gopingme.lobb.ie` from the development machine. No mail was submitted. Live
Turnstile, cross-origin submission, redirects and received-email acceptance
remain unverified. The form page remains enabled pending that validation.

## Deployment handoff, 2026-11-08

The operator confirmed GitHub Pages was unpublished and authorized deployment
to `kepler452`, including replacement of conflicting DNS for
`demo.theme.tadg.ie`. The Pages deploy job remains disabled.

The implementation was published in commit `a34334e` (reusable Go Ping Me forms
and Exodan demo configuration). This supported CLI invocation was attempted:

```sh
deploy-nix --verbose --force-dns-overwrite /Users/tigger/code/www/hugo-theme-first-folio/exampleSite kepler452 master
```

It exited 1 with `invalid application directory name`, following a fleet-alert
notice. No successful Exodan deployment is evidenced. The integration contract
needs a supported route for this repository's `exampleSite` subdirectory;
application-side directory renaming or copied deployment machinery has not been
introduced to bypass the failure. Resolve that interface with the infrastructure
owner before retrying the authorized cutover.

Outstanding external evidence is the published `customform` schema contract,
service DNS and origin authorization, a successful demo deployment, and the
operator's real Turnstile and received-email checks. The demo form must not be
marked validated or disabled as a proven example until those checks occur.
