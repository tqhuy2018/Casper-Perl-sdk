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

# This function parse the JsonObject (taken from server RPC method call) to get the Delegator object

sub fromJsonToDelegator {
	
}