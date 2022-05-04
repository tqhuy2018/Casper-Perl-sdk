# Class built for storing ExecutionEffect information

package GetDeploy::ExecutionResult::ExecutionEffect;
use GetDeploy::ExecutionResult::TransformEntry;

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
	print "\ntotal Operations:".$totalOperation." and total transform:".$totalTransform."\n";
	my $ret = new GetDeploy::ExecutionResult::ExecutionEffect();
	if ($totalOperation > 0) {
		my @listOperation = ();
		foreach(@operationJsonList) {
			
		}
		$ret->setOperations(@listOperation);		
	}
	if ($totalTransform > 0) {
		my @listTransform = ();
		foreach(@transformJsonList) {
			my $oneTransformJson = $_;
			my $oneTransformEntry = GetDeploy::ExecutionResult::TransformEntry->fromJsonToCasperTransform($oneTransformJson);
			push(@listTransform,$oneTransformEntry);
		}
		$ret->setTransforms(@listTransform);
	}
	return $ret;
}
1;