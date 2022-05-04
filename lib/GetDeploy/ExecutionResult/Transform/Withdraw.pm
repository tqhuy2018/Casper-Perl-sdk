# Class built for storing Withdraw information

package GetDeploy::ExecutionResult::Transform::Withdraw;

sub new {
	my $class = shift,
	my $self = {
		_listUnbondingPurse => [ @_ ], # List of UnbondingPurse object
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonArray (taken from server RPC method call) to get the Withdraw object with UnbondingPurse list
sub fromJsonArrayToWithdraw {
	
}