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

# get-set method for _key
sub setKey {
	my ( $self, $key) = @_;
	$self->{_key} = $key if defined($key);
	return $self->{_key};
}

sub getKey {
	my ( $self ) = @_;
	return $self->{_key};
}

# get-set method for _transform
sub setTransform {
	my ( $self, $transform) = @_;
	$self->{_transform} = $transform if defined($transform);
	return $self->{_transform};
}

sub getTransform {
	my ( $self ) = @_;
	return $self->{_transform};
}

# This function parse the JsonObject (taken from server RPC method call) to get the TransformEntry object
sub fromJsonToCasperTransform {
	
}
1;