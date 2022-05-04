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

# get-set method for _operations
sub setOperations {
	my ($self,@operations) = @_;
	$self->{_operations} = \@operations;
	return $self->{_operations};
}
sub getOperations {
	my ($self) = @_;
	my @ret = @ {$self->{_operations}};
	wantarray ? @ret : \@ret;
}
# get-set method for _transforms

sub setTransforms {
	my ($self,@transform) = @_;
	$self->{_transforms} = \@transform;
	return $self->{_transforms};
}
sub getTransforms {
	my ($self) = @_;
	my @ret = @ {$self->{_transforms}};
	wantarray ? @ret : \@ret;
}
# This function parse the JsonObject (taken from server RPC method call) to get the ExecutionEffect object
sub fromJsonToExecutionEffect {
	
}