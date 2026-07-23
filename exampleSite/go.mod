// There is no actual go module or hugo module here.
// This is apparently how exampleSites are deployed.
// It is one big vainglorious hack. I feel dirty.

module github.com/tigger-developer/hugo-theme-first-folio/exampleSite

go 1.26.2

require github.com/tigger-developer/hugo-theme-first-folio v1.0.7

replace github.com/tigger-developer/hugo-theme-first-folio => ../
