# Class built for storing TransformEntry information

package GetDeploy::ExecutionResult::TransformEntry;

sub new {
	my $class = shift;
	my $self = {
		_key => shift,
		_transform => shift, # CasperTransform object
	};
	bless $self, $class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the TransformEntry object

sub fromJsonToCasperTransform {
	
}