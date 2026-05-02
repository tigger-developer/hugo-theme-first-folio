#!/usr/bin/env perl
# add-license-header.pl
# Prefix Apache 2.0 SPDX header to source files.
# Skips files that already carry any licence marker.

use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';

my $copyright = 'Copyright (c) 2023 Taḋg Paul';
my $spdx      = 'SPDX-License-Identifier: Apache-2.0';
my $note      = 'See LICENSE file in the repository root.';

# Comment styles per extension: [open, line-prefix, close]
# Empty open/close means line-comment style.
my %styles = (
    css     => ['/*',   ' * ', ' */'],
    html    => ['<!--', ' ',   '-->'],
    xml     => ['<!--', ' ',   '-->'],
    pl      => ['',     '# ',  ''],
    sh      => ['',     '# ',  ''],
    toml    => ['',     '# ',  ''],
    org     => ['',     '# ',  ''],
);

# Lines that must remain first in the file
sub leading_line_to_preserve {
    my ($line) = @_;
    return 1 if $line =~ /^#!/;            # shebang
    return 1 if $line =~ /^<\?xml/;        # XML declaration
    return 1 if $line =~ /^<!DOCTYPE/i;    # doctype
    return 0;
}

sub already_tagged {
    my ($content) = @_;
    return $content =~ /SPDX-License-Identifier|Apache License|MIT License|BSD License|Copyright\s*\(c\)|Copyright\s*©/i;
}

sub build_header {
    my ($style) = @_;
    my ($open, $prefix, $close) = @$style;
    my @lines;
    push @lines, $open if $open ne '';
    push @lines, "${prefix}${copyright}";
    push @lines, "${prefix}${spdx}";
    push @lines, "${prefix}${note}";
    push @lines, $close if $close ne '';
    return join("\n", @lines) . "\n\n";
}

my $tagged = 0;
my $skipped = 0;

for my $file (@ARGV) {
    unless (-f $file) {
        warn "skip (not a file): $file\n";
        $skipped++;
        next;
    }

    my ($ext) = $file =~ /\.([^.\/]+)$/;
    $ext = lc($ext // '');

    unless ($styles{$ext}) {
        warn "skip (unhandled type .$ext): $file\n";
        $skipped++;
        next;
    }

    open my $fh, '<:encoding(UTF-8)', $file or do {
        warn "cannot read $file: $!\n";
        $skipped++;
        next;
    };
    my $content = do { local $/; <$fh> };
    close $fh;

    if (already_tagged($content)) {
        warn "skip (already tagged): $file\n";
        $skipped++;
        next;
    }

    my $header = build_header($styles{$ext});
    my $new;

    if ($content =~ /\A([^\n]*\n)/ && leading_line_to_preserve($1)) {
        my $first = $1;
        my $rest  = substr($content, length($first));
        $new = $first . $header . $rest;
    } else {
        $new = $header . $content;
    }

    open my $out, '>:encoding(UTF-8)', $file or do {
        warn "cannot write $file: $!\n";
        $skipped++;
        next;
    };
    print $out $new;
    close $out;

    print "tagged: $file\n";
    $tagged++;
}

print STDERR "\nDone. Tagged: $tagged. Skipped: $skipped.\n";
