# Class built for storing SeigniorageAllocation information
# and handles the change from Json object to SeigniorageAllocation object
package GetDeploy::ExecutionResult::Transform::SeigniorageAllocation;

sub new {
	my $class = shift,
	my $self = {
		_isValidator => shift,
		_validatorPublicKey => shift,
		_amount => shift,
		_delegatorPublicKey => shift,
	};
	bless $self,$class;
	return $self;
}

# get-set method for _isValidator
sub setIsValidator {
	my ($self,$value) = @_;
	$self->{_isValidator} = $value if defined($value);
	return $self->{_isValidator};
}
sub getIsValidator {
	my ($self)  = @_;
	return $self->{_isValidator};
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

# get-set method for _delegatorPublicKey
sub setDelegatorPublicKey {
	my ($self,$value) = @_;
	$self->{_delegatorPublicKey} = $value if defined($value);
	return $self->{_delegatorPublicKey};
}
sub getDelegatorPublicKey {
	my ($self)  = @_;
	return $self->{_delegatorPublicKey};
}

#This function parse the JsonObject (taken from server RPC method call) to get the SeigniorageAllocation object
sub fromJsonToSeigniorageAllocation {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::SeigniorageAllocation();
	my $validatorJson = $json->{'Validator'};
	my $delegatorJson = $json->{'Delegator'};
	if($validatorJson) {
		$ret->setIsValidator(1);
		$ret->setValidatorPublicKey($validatorJson->{'validator_public_key'});
		$ret->setAmount($validatorJson->{'amount'});
	} else {
		$ret->setIsValidator(0);
		$ret->setValidatorPublicKey($delegatorJson->{'validator_public_key'});
		$ret->setAmount($delegatorJson->{'amount'});
		$ret->setDelegatorPublicKey($delegatorJson->{'delegator_public_key'});
	}
	return $ret;
}
1;