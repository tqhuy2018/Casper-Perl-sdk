# Class built for storing Delegator information
# and handles the change from Json object to Delegator object
package GetDeploy::ExecutionResult::Transform::Delegator;
use GetDeploy::ExecutionResult::Transform::VestingSchedule;
sub new {
	my $class = shift,
	my $self = {
		_publicKey => shift,
		_bondingPurse => shift,
		_stakedAmount => shift, 
		_validatorPublicKey => shift,
		_delegatorPublicKey => shift,
		_vestingSchedule => shift, # Optional value of type VestingSchedule
		_isVSExists => shift, # This attribute hold the information to indicate that VestingSchedule exists or not
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

# get-set method for _isVSExists
sub setIsVSExists {
	my ($self,$publicKey) = @_;
	$self->{_isVSExists} = $publicKey if defined($publicKey);
	return $self->{_isVSExists};
}
sub getIsVSExists {
	my ($self)  = @_;
	return $self->{_isVSExists};
}

# This function parse the JsonObject (taken from server RPC method call) to get the Delegator object
sub fromJsonToDelegator {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::Delegator();
	$ret->setBondingPurse($json->{'bonding_purse'});
	$ret->setStakedAmount($json->{'staked_amount'});
	$ret->setValidatorPublicKey($json->{'validator_public_key'});
	$ret->setDelegatorPublicKey($json->{'delegator_public_key'});
	my $vsJson = $json->{'vesting_schedule'};
	# get VestingSchedule
	if($vsJson) {
		my $vs = GetDeploy::ExecutionResult::Transform::VestingSchedule->fromJsonToVestingSchedule($vsJson);
		$ret->setVestingSchedule($vs);
		$ret->setIsVSExists(1);
	} else {
		$ret->setIsVSExists(0);
	}
	return $ret;
}
1;