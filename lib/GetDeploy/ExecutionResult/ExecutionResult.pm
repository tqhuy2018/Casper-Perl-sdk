# Class built for storing ExecutionResult information

package GetDeploy::ExecutionResult::ExecutionResult;

sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_cost => shift,
		_errorMessage => shift,
		_effect => shift, # ExecutionEffect object
		_transfers => [ @_ ], # List of string
	};
	bless $self, $class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the ExecutionResult object
sub fromJsonToExecutionResult{
	
}