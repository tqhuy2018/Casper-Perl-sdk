# Class built for storing VestingSchedule information

package GetDeploy::ExecutionResult::Transform::VestingSchedule;

sub new {
	my $class = shift,
	my $self = {
		_initialReleaseTimestampMillis => shift,
		_lockedAmounts => [ @_ ], # List of U512Class object
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the VestingSchedule object
sub fromJsonToVestingSchedule {
	
}