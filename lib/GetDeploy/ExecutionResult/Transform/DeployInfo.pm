# Class built for storing DeployInfo information

package GetDeploy::ExecutionResult::Transform::DeployInfo;

sub new {
	my $class = shift,
	my $self = {
		_deployHash => shift,
		_from => shift,
		_source => shift, 
		_gas => shift,
		_transfers => [ @_ ] , # TransferAddr list of type String
	};
	bless $self,$class;
	return $self;
}

# get-set method for _deployHash
sub setDeployHash {
	my ($self,$deployHash) = @_;
	$self->{_deployHash} = $deployHash if defined($deployHash);
	return $self->{_deployHash};
}
sub getDeployHash {
	my ($self)  = @_;
	return $self->{_deployHash};
}

# get-set method for _from
sub setFrom {
	my ($self,$from) = @_;
	$self->{_from} = $from if defined($from);
	return $self->{_from};
}
sub getFrom {
	my ($self)  = @_;
	return $self->{_from};
}

# get-set method for _source
sub setSource {
	my ($self,$source) = @_;
	$self->{_source} = $source if defined($source);
	return $self->{_source};
}
sub getSource {
	my ($self)  = @_;
	return $self->{_source};
}

# get-set method for _gas
sub setGas {
	my ($self,$gas) = @_;
	$self->{_gas} = $gas if defined($gas);
	return $self->{_gas};
}
sub getGas {
	my ($self)  = @_;
	return $self->{_gas};
}

# get-set method for _transfers
sub setTransfers {
	my ($self,@transfers) = @_;
	$self->{_transfers} = \@transfers;
	return $self->{_transfers};
}
sub getTransfers {
	my ($self)  = @_;
	my @ret = @ {$self->{_transfers}};
	wantarray ? @ret : \@ret;
}

# This function parse the JsonObject (taken from server RPC method call) to get the DeployInfo object
sub fromJsonToDeployInfo {
	
}