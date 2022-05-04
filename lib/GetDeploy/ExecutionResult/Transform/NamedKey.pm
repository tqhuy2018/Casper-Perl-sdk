# Class built for storing NamedKey information

package GetDeploy::ExecutionResult::Transform::NamedKey;

sub new {
	my $class = shift,
	my $self = {
		_name => shift,
		_key => shift,
	};
	bless $self,$class;
	return $self;
}

# This function parse the JsonObject (taken from server RPC method call) to get the NamedKey object

sub fromJsonObjectToNamedKey {
	
}