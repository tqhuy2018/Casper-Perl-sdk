# Class built for storing GetBalanceParams information. This class generate the string parameter to send the 
# post method for the state_get_balance RPC call
package GetBalance::GetBalanceParams;
sub new {
	my $class = shift;
	my $self = {
		_stateRootHash => shift,
		_purseUref => shift, 
	};
	bless $self, $class;
	return $self;
}

# get-set method for _stateRootHash
sub setStateRootHash {
	my ( $self, $value) = @_;
	$self->{_stateRootHash} = $value if defined($value);
	return $self->{_stateRootHash};
}

sub getStateRootHash {
	my ( $self ) = @_;
	return $self->{_stateRootHash};
}

# get-set method for _purseUref
sub setPurseUref {
	my ( $self, $value) = @_;
	$self->{_purseUref} = $value if defined($value);
	return $self->{_purseUref};
}

sub getPurseUref {
	my ( $self ) = @_;
	return $self->{_purseUref};
}

# This function generate the parameter for the post method of the state_get_balance RPC call
sub generateParameterStr {
	my ($self) = @_;
	return '{"id": 1, "method": "'.$Common::ConstValues::RPC_GET_BALANCE.'" , "params": {"state_root_hash": "'.$self->{_stateRootHash}.'", "purse_uref": "'.$self->{_purseUref}.'"},  "jsonrpc": "2.0"}';
}
1;
