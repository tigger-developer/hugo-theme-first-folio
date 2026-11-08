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
    turnstile:
      enabled: false
    forms:
      general-enquiry:
        schema: contact
      project-enquiry:
        schema: contact
```

The service origin must be an absolute HTTPS root URL with a trailing slash,
without credentials, query, fragment or a non-default port. Explicit port 443
is accepted. Every form posts to that exact URL.

`forms` must be a non-empty map. Each entry requires `schema`. Only the published
`contact` schema is currently supported. Unknown
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
when disabled. The theme does not configure or render a Turnstile action.
The receiving service endpoint must recognize this public key and authorize the
website's exact origin. No secret belongs in Hugo configuration.

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

## Multiple forms and submission

Named forms can be mixed or repeated on the same page. Each instance gets unique
IDs and associated labels. Every form uses standard HTML submission with one
native submit button. The theme loads no submission helper and adds no submit
listener, status region, duplicate-prevention state or browser API. The service
responds through its standard redirect contract, giving each downstream website
control of its success and failure pages. Turnstile-disabled forms work without
JavaScript. Turnstile-enabled forms still require JavaScript to obtain a token,
and the provider script loads once per page.

## Content Security Policy

Add the service origin to `form-action`. Turnstile needs
`https://challenges.cloudflare.com` in `script-src` and `frame-src`. Review
[Cloudflare's current CSP guidance](https://developers.cloudflare.com/turnstile/reference/content-security-policy/)
for the consuming site's policy. The theme does not replace the site's CSP.
Infrastructure and the service own cross-origin policy; the theme does not
configure CORS or claim that another origin is authorized.

## Migration

Migration is deliberate: add `params.go_ping_me`, replace the selected old
invocation, create the site's success and failure pages, and configure service
policy outside the theme. Existing shortcodes are not migrated automatically.

## Verification

Run `./tests/go-ping-me/render.mjs` for isolated local Hugo builds and HTML
assertions, or `make test` for those checks plus the existing regression suite.
Tests never contact Turnstile, the mail service or a hosted model. They cover
native output, multiple named/repeated forms, independent site
configuration, field restrictions and malformed configuration.

Real browser verification, service redirects and received-email acceptance are
separate operator checks, not outcomes established by the local tests.
