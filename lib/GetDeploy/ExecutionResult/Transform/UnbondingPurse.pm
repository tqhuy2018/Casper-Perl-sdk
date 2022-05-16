# Class built for storing UnbondingPurse information
# and handles the change from Json object to UnbondingPurse object
package GetDeploy::ExecutionResult::Transform::UnbondingPurse;
sub new {
	my $class = shift,
	my $self = {
		_bondingPurse => shift,
		_validatorPublicKey => shift,
		_unbonderPublicKey => shift,
		_eraOfCreation => shift,
		_amount => shift,
	};
	bless $self,$class;
	return $self;
}

# get-set method for _bondingPurse
sub setBondingPurse {
	my ($self,$value) = @_;
	$self->{_bondingPurse} = $value if defined($value);
	return $self->{_bondingPurse};
}
sub getBondingPurse {
	my ($self)  = @_;
	return $self->{_bondingPurse};
}

# get-set method for _validatorPublicKey
sub setValidatorPublicKey {
	my ($self,$value) = @_;
	$self->{_validatorPublicKey} = $value if defined($value);
	return $self->{_validatorPublicKey};
}
sub getValidatorPublicKey {
	my ($self)  = @_;
	return $self->{_validatorPublicKey};
}

# get-set method for _unbonderPublicKey
sub setUnbonderPublicKey {
	my ($self,$value) = @_;
	$self->{_unbonderPublicKey} = $value if defined($value);
	return $self->{_unbonderPublicKey};
}
sub getUnbonderPublicKey {
	my ($self)  = @_;
	return $self->{_unbonderPublicKey};
}

# get-set method for _eraOfCreation
sub setEraOfCreation {
	my ($self,$value) = @_;
	$self->{_eraOfCreation} = $value if defined($value);
	return $self->{_eraOfCreation};
}
sub getEraOfCreation {
	my ($self)  = @_;
	return $self->{_eraOfCreation};
}

# get-set method for _amount
sub setAmount {
	my ($self,$value) = @_;
	$self->{_amount} = $value if defined($value);
	return $self->{_amount};
}
sub getAmount {
	my ($self)  = @_;
	return $self->{_amount};
}

# This function parse the JsonObject (taken from server RPC method call) to get the UnbondingPurse object
sub fromJsonToUnbondingPurse {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::UnbondingPurse();
	$ret->setBondingPurse($json->{'bonding_purse'});
	$ret->setAmount($json->{'amount'});
	$ret->setEraOfCreation($json->{'era_of_creation'});
	$ret->setUnbonderPublicKey($json->{'unbonder_public_key'});
	$ret->setValidatorPublicKey($json->{'validator_public_key'});
	return $ret;
}
1;
1;