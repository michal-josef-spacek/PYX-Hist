# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'A perl module for PYX handling.';
author 'Michal Spacek <skim@cpan.org>';
license 'bsd';
name 'PYX-Hist';
readme_from 'Hist.pm';
requires 'Class::Utils' => 0.05;
requires 'Error::Pure' => 0.16;
requires 'List::Util' => 0;
requires 'PYX::Parser' => 0.02;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=PYX-Hist';
resources 'homepage' => 'https://github.com/tupinek/PYX-Hist';
resources 'repository' => 'git://github.com/tupinek/PYX-Hist';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.07;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
