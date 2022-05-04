# Class built for storing UnbondingPurse information

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

# This function parse the JsonObject (taken from server RPC method call) to get the UnbondingPurse object
sub fromJsonToUnbondingPurse {
	
}