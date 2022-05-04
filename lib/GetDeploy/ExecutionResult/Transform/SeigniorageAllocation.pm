# Class built for storing SeigniorageAllocation information

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

#This function parse the JsonObject (taken from server RPC method call) to get the SeigniorageAllocation object
sub fromJsonToSeigniorageAllocation {
	
}