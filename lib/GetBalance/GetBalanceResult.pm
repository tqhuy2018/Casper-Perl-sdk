# Class built for storing GetBalanceResult information, taken from state_get_balance RPC method
package GetBalance::GetBalanceResult;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_balanceValue => shift, 
		_merkleProof => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _apiVersion
sub setApiVersion {
	my ( $self, $value) = @_;
	$self->{_apiVersion} = $value if defined($value);
	return $self->{_apiVersion};
}

sub getApiVersion {
	my ( $self ) = @_;
	return $self->{_apiVersion};
}

# get-set method for _balanceValue
sub setBalanceValue {
	my ( $self, $value) = @_;
	$self->{_balanceValue} = $value if defined($value);
	return $self->{_balanceValue};
}

sub getBalanceValue {
	my ( $self ) = @_;
	return $self->{_balanceValue};
}

# get-set method for _merkleProof
sub setMerkleProof {
	my ( $self, $value) = @_;
	$self->{_merkleProof} = $value if defined($value);
	return $self->{_merkleProof};
}

sub getMerkleProof {
	my ( $self ) = @_;
	return $self->{_merkleProof};
}

# This function parse the JsonObject (taken from server RPC method call) to generate the GetBalanceResult object
sub fromJsonToGetBalanceResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBalance::GetBalanceResult();
	$ret->setApiVersion($json->{'api_version'});
	$ret->setMerkleProof($json->{'merkle_proof'});
	$ret->setBalanceValue($json->{'balance_value'});
	return $ret;
}
1;