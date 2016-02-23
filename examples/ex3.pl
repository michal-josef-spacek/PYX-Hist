#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure;
use PYX::Hist;

# Error output.
$Error::Pure::TYPE = 'PrintVar';

# Example data.
my $pyx = <<'END';
(begin
(middle
(end
-data
)end
)middle
END

# PYX::Hist object.
my $obj = PYX::Hist->new;

# Parse.
$obj->parse($pyx);

# Output:
# PYX::Hist: Stack has some elements.