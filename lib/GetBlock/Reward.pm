# Class built for storing Reward information
package GetBlock::Reward;

sub new {
	my $class = shift;
	my $self = {
		_validator => shift, 
		_amount => shift,
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

# get-set method for _validator
sub setAmount {
	my ( $self, $value) = @_;
	$self->{_amount} = $value if defined($value);
	return $self->{_amount};
}

sub getAmount {
	my ( $self ) = @_;
	return $self->{_amount};
}

# This function parse the JsonObject (taken from server RPC method call) to Reward object
sub fromJsonToReward {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::Reward();
	$ret->setValidator($json->{'validator'});
	$ret->setAmount($json->{'amount'});
	return $ret;
}