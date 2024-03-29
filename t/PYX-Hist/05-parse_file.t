use strict;
use warnings;

use Capture::Tiny qw(capture);
use English;
use Error::Pure::Utils qw(clean);
use File::Object;
use PYX::Hist;
use Test::More 'tests' => 5;
use Test::NoWarnings;

# Data directory.
my $data_dir = File::Object->new->up->dir('data')->set;

# Test.
my $obj = PYX::Hist->new;
my ($stdout, $stderr) = capture sub {
	$obj->parse_file($data_dir->file('ex1.pyx')->s);
};
is($stdout, <<'END', 'Stdout output.');
[ data ] 2
[ pyx  ] 1
END
is($stderr, '', 'Stderr output.');

# Test.
$obj = PYX::Hist->new;
eval {
	$obj->parse_file($data_dir->file('ex2.pyx')->s);
};
is($EVAL_ERROR, "Stack has some elements.\n", 'Stack has some elements.');
clean();

# Test.
$obj = PYX::Hist->new;
eval {
	$obj->parse_file($data_dir->file('ex3.pyx')->s);
};
is($EVAL_ERROR, "Bad end of element.\n", 'Bad end of element.');
clean();
