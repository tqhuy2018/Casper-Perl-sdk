# Class built for storing Delegator information

package GetDeploy::ExecutionResult::Transform::Delegator;

sub new {
	my $class = shift,
	my $self = {
		_publicKey => shift,
		_bondingPurse => shift,
		_stakedAmount => shift, 
		_validatorPublicKey => shift,
		_delegatorPublicKey => shift,
		_vestingSchedule => shift, # Optional value of type VestingSchedule
	};
	bless $self,$class;
	return $self;
}

# get-set method for _publicKey
sub setPublicKey {
	my ($self,$publicKey) = @_;
	$self->{_publicKey} = $publicKey if defined($publicKey);
	return $self->{_publicKey};
}
sub getPublicKey {
	my ($self)  = @_;
	return $self->{_publicKey};
}

# get-set method for _bondingPurse
sub setBondingPurse {
	my ($self,$bondingPurse) = @_;
	$self->{_bondingPurse} = $bondingPurse if defined($bondingPurse);
	return $self->{_bondingPurse};
}
sub getBondingPurse {
	my ($self)  = @_;
	return $self->{_bondingPurse};
}

# get-set method for _stakedAmount
sub setStakedAmount {
	my ($self,$stakedAmount) = @_;
	$self->{_stakedAmount} = $stakedAmount if defined($stakedAmount);
	return $self->{_stakedAmount};
}
sub getStakedAmount {
	my ($self)  = @_;
	return $self->{_stakedAmount};
}

# get-set method for _validatorPublicKey
sub setValidatorPublicKey {
	my ($self,$validatorPublicKey) = @_;
	$self->{_validatorPublicKey} = $validatorPublicKey if defined($validatorPublicKey);
	return $self->{_validatorPublicKey};
}
sub getValidatorPublicKey {
	my ($self)  = @_;
	return $self->{_validatorPublicKey};
}

# get-set method for _delegatorPublicKey
sub setDelegatorPublicKey {
	my ($self,$delegatorPublicKey) = @_;
	$self->{_delegatorPublicKey} = $delegatorPublicKey if defined($delegatorPublicKey);
	return $self->{_delegatorPublicKey};
}
sub getDelegatorPublicKey {
	my ($self)  = @_;
	return $self->{_delegatorPublicKey};
}

# get-set method for _vestingSchedule
sub setVestingSchedule {
	my ($self,$vestingSchedule) = @_;
	$self->{_vestingSchedule} = $vestingSchedule if defined($vestingSchedule);
	return $self->{_vestingSchedule};
}
sub getVestingSchedule {
	my ($self)  = @_;
	return $self->{_vestingSchedule};
}

# This function parse the JsonObject (taken from server RPC method call) to get the Delegator object
sub fromJsonToDelegator {
	
}