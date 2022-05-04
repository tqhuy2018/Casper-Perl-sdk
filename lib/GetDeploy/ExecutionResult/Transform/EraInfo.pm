# Class built for storing EraInfo information

package GetDeploy::ExecutionResult::Transform::EraInfo;

sub new {
	my $class = shift,
	my $self = {
		_seigniorageAllocations => [ @_ ] , # List of SeigniorageAllocation object
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the EraInfo object

sub fromJsonArrayToEraInfo {
	
}