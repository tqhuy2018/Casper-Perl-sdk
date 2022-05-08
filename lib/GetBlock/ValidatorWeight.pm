# Class built for storing ValidatorWeight information
package GetBlock::ValidatorWeight;

sub new {
	my $class = shift;
	my $self = {
		_validator => shift, 
		_weight => [ @_ ],
	};
	bless $self, $class;
	return $self;
}

# get-set method for _validator
sub setValidator {
	my ( $self, $value) = @_;
	$self->{_validator} = $value if defined($value);
	return $self->{_validator};
}

sub getValidator {
	my ( $self ) = @_;
	return $self->{_validator};
}

# get-set method for _weight
sub setWeight {
	my ( $self, $value) = @_;
	$self->{_weight} = $value if defined($value);
	return $self->{_weight};
}

sub getWeight {
	my ( $self ) = @_;
	return $self->{_weight};
}

# This function parse the JsonObject (taken from server RPC method call) to ValidatorWeight object
sub fromJsonToValidatorWeight {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::ValidatorWeight();
	$ret->setValidator($json->{'validator'});
	$ret->setWeight($json->{'weight'});
	return $ret;
}