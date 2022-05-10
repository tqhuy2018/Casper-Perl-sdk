# Class built for storing JsonValidatorWeights information
package GetAuction::JsonValidatorWeights;
sub new {
	my $class = shift;
	my $self = {
		_publicKey => shift, 
		_weight => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _publicKey
sub setPublicKey {
	my ( $self, $value) = @_;
	$self->{_publicKey} = $value if defined($value);
	return $self->{_publicKey};
}

sub getPublicKey {
	my ( $self ) = @_;
	return $self->{_publicKey};
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

# This function parse the JsonObject (taken from server RPC method call) to JsonValidatorWeights object
sub fromJsonObjectToJsonValidatorWeights {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::JsonValidatorWeights();
	$ret->setPublicKey($json->{'public_key'});
	$ret->setWeight($json->{'weight'});
	return $ret;
}
1;