package PYX::Hist;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use List::Util qw(reduce);
use PYX::Parser;

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Output handler.
	$self->{'output_handler'} = \*STDOUT;

	# Process params.
	set_params($self, @params);

	# PYX::Parser object.
	$self->{'_pyx_parser'} = PYX::Parser->new(
		'callbacks' => {
			'end_element' => \&_end_element,
			'final' => \&_final,
			'start_element' => \&_start_element,
		},
		'non_parser_options' => {
			'hist' => {},
			'stack' => [],
		},
		'output_handler' => $self->{'output_handler'},
	);

	# Object.
	return $self;
}

# Parse pyx text or array of pyx text.
sub parse {
	my ($self, $pyx, $out) = @_;
	$self->{'_pyx_parser'}->parse($pyx, $out);
	return;
}

# Parse file with pyx text.
sub parse_file {
	my ($self, $file, $out) = @_;
	$self->{'_pyx_parser'}->parse_file($file, $out);
	return;
}

# Parse from handler.
sub parse_handler {
	my ($self, $input_file_handler, $out) = @_;
	$self->{'_pyx_parser'}->parse_handler($input_file_handler, $out);
	return;
}

# End of element.
sub _end_element {
	my ($pyx_parser_obj, $elem) = @_;
	my $stack_ar = $pyx_parser_obj->{'non_parser_options'}->{'stack'};
	my $out = $pyx_parser_obj->{'output_handler'};
	if ($stack_ar->[-1] eq $elem) {
		pop @{$stack_ar};
	} elsif ($pyx_parser_obj->{'non_parser_options'}->{'bad_end'}) {
		err 'Bad end of element.',
			'Element', $elem;
	}
	return;
}

# Finalize.
sub _final {
	my $pyx_parser_obj = shift;
	my $stack_ar = $pyx_parser_obj->{'non_parser_options'}->{'stack'};
	if (@{$stack_ar} > 0) {
		err 'Stack has some elements.';
	}
	my $hist_hr = $pyx_parser_obj->{'non_parser_options'}->{'hist'};
	my $max_len = length reduce { length($a) > length($b) ? $a : $b }
		keys %{$hist_hr};
	foreach my $key (sort keys %{$hist_hr}) {
		printf "[ %-${max_len}s ] %s\n", $key, $hist_hr->{$key};
	}
	return;
}

# Start of element.
sub _start_element {
	my ($pyx_parser_obj, $elem) = @_;
	my $stack_ar = $pyx_parser_obj->{'non_parser_options'}->{'stack'};
	my $out = $pyx_parser_obj->{'output_handler'};
	push @{$stack_ar}, $elem;
	if (! $pyx_parser_obj->{'non_parser_options'}->{'hist'}->{$elem}) {
		$pyx_parser_obj->{'non_parser_options'}->{'hist'}->{$elem} = 1;
	} else {
		$pyx_parser_obj->{'non_parser_options'}->{'hist'}->{$elem}++;
	}
	return;
}

1;

__END__
