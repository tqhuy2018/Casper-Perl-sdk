# Class built for storing DeployInfo information

package GetDeploy::ExecutionResult::Transform::DeployInfo;

sub new {
	my $class = shift,
	my $self = {
		_deployHash => shift,
		_from => shift,
		_source => shift, 
		_gas => shift,
		_transfers => [ @_ ] , # TransferAddr list of type String
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the DeployInfo object

sub fromJsonToDeployInfo {
	
}