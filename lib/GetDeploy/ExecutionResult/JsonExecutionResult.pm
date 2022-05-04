# Class built for storing JsonExecutionResult information

package GetDeploy::ExecutionResult::JsonExecutionResult;

sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_result => shift, # ExecutionResult object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _blockHash
sub setBlockHash {
	my ( $self, $blockHash) = @_;
	$self->{_blockHash} = $blockHash if defined($blockHash);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}

# get-set method for _result
sub setResult {
	my ( $self, $result) = @_;
	$self->{_result} = $result if defined($result);
	return $self->{_result};
}

sub getResult {
	my ( $self ) = @_;
	return $self->{_result};
}

# This function parse the JsonObject (taken from server RPC method call) to get the JsonExecutionResult object
sub fromJsonToJsonExecutionResult{
	
}