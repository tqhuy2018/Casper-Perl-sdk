# Class built for storing Bid information

package GetDeploy::ExecutionResult::Transform::Bid;

sub new {
	my $class = shift;
	my $self = {
		_bondingPurse => shift,
		_delegationRate => shift,
		_inactive => shift,
		_delegators => [ @_ ], # list of Delegator
		_stakedAmount => shift, # of type U512
		_validatorPublicKey => shift,
		_vestingSchedule => shift, # Optional value of type VestingSchedule
	};
	bless $self, $class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the Bid object

sub fromJsonToBid {
	
}