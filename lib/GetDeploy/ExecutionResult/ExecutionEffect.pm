# Class built for storing ExecutionEffect information
# and handles the change from Json object to ExecutionEffect object
package GetDeploy::ExecutionResult::ExecutionEffect;
use GetDeploy::ExecutionResult::TransformEntry;
use GetDeploy::ExecutionResult::CasperOperation;

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
	my @list = @_;
	my $json = $list[1];
	my @operationJsonList = @{ $json->{'operations'} };
	my @transformJsonList = @{ $json->{'transforms'}};
	my $totalOperation = @operationJsonList;
	my $totalTransform = @transformJsonList;
	my $ret = new GetDeploy::ExecutionResult::ExecutionEffect();
	if ($totalOperation > 0) {
		my @listOperation = ();
		foreach(@operationJsonList) {
			my $oneOperation = GetDeploy::ExecutionResult::CasperOperation->fromJsonObjectToCasperOperation($_);
			push(@listOperation,$oneOperation);
		}
		$ret->setOperations(@listOperation);
	}
	if ($totalTransform > 0) {
		my @listTransform = ();
		foreach(@transformJsonList) {
			my $oneTransformEntry = GetDeploy::ExecutionResult::TransformEntry->fromJsonToCasperTransform($_);
			push(@listTransform,$oneTransformEntry);
		}
		$ret->setTransforms(@listTransform);
	}
	return $ret;
}
1;