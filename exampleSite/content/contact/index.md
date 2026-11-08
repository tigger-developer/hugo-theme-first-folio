---
title: Contact form demonstration
description: Native and enhanced forms using the same Go Ping Me service.
hideDate: true
noindex: true
---

This page demonstrates two independently configured forms. Submissions from the
live demo send real email. Please use it only for the coordinated integration
test and do not include sensitive information.

## General enquiry

This form shows inline submission feedback. Company and interests are additional
fields supplied through the shared child shortcode.

{{< go-ping-me form="general-enquiry" >}}
  {{< go-ping-me-field name="company" type="text" label="Company (optional)" autocomplete="organization" >}}
  {{< go-ping-me-field name="interest" type="checkbox" label="Writing" value="writing" >}}
  {{< go-ping-me-field name="interest" type="checkbox" label="Technology" value="technology" >}}
{{< /go-ping-me >}}

## Project enquiry

This form uses native submission and navigates to the configured result page.
When Turnstile is enabled, JavaScript is still required for its verification
widget.

{{< go-ping-me form="project-enquiry" />}}
