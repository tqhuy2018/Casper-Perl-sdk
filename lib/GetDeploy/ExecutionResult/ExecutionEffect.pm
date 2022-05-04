# Class built for storing ExecutionEffect information

package GetDeploy::ExecutionResult::ExecutionEffect;

sub new {
	my $class = shift;
	my $self = {
		_operations => [ @_ ], # list of CasperOperation object
		_transforms => [ @_ ], # list of TransformEntry object
	};
	bless $self, $class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the ExecutionEffect object
sub fromJsonToExecutionEffect {
	
}