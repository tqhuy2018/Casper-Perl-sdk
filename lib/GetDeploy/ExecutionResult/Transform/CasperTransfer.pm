# Class built for storing Bid information

package GetDeploy::ExecutionResult::Transform::CasperTransfer;

sub new {
	my $class = shift,
	my $self = {
		_deployHash => shift,
		_from => shift,
		_to => shift, # Optional value
		_id => shift, # Optional value
		_source => shift,
		_target => shift,
		_amount => shift, 
		_gas => shift,
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the CasperTransfer object

sub fromJsonToTransfer {
	
}
