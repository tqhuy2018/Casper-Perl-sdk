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

# get-set method for _itsType
sub setItsType {
	my ($self,$itsType) = @_;
	$self->{_itsType} = $itsType if defined ($itsType);
	return $self->{_itsType};
}

sub getItsType {
	my ($self) = @_;
	return $self->{_itsType};
}

# get-set method for _cost
sub setCost {
	my ($self,$cost) = @_;
	$self->{_cost} = $cost if defined ($cost);
	return $self->{_cost};
}

sub getCost {
	my ($self) = @_;
	return $self->{_cost};
}

# get-set method for _errorMessage
sub setErrorMessage {
	my ($self,$errorMessage) = @_;
	$self->{_errorMessage} = $errorMessage if defined ($errorMessage);
	return $self->{_errorMessage};
}

sub getErrorMessage {
	my ($self) = @_;
	return $self->{_errorMessage};
}

# get-set method for _effect
sub setEffect {
	my ($self,$effect) = @_;
	$self->{_effect} = $effect if defined ($effect);
	return $self->{_effect};
}

sub getEffect {
	my ($self) = @_;
	return $self->{_effect};
}

# get-set method for _transfers
sub setTransfers {
	my ($self,@transfer) = @_;
	$self->{_transfers} = \@transfer;
	return $self->{_transfers};
}

sub getTransfers {
	my ($self) = @_;
	my @ret = @{$self->{_transfers}};
	wantarray ? @ret : \@ret;
}
# This function parse the JsonObject (taken from server RPC method call) to get the ExecutionResult object
sub fromJsonToExecutionResult{
	
}
1;