# Class built for storing JsonDelegator information
package GetAuction::JsonDelegator;
sub new {
	my $class = shift;
	my $self = {
		_bondingPurse => shift,
		_delegatee => shift,
		_publicKey => shift,
		_stakedAmount => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _bondingPurse
sub setBondingPurse {
	my ( $self, $value) = @_;
	$self->{_bondingPurse} = $value if defined($value);
	return $self->{_bondingPurse};
}

sub getBondingPurse {
	my ( $self ) = @_;
	return $self->{_bondingPurse};
}

# get-set method for _delegatee
sub setDelegatee {
	my ( $self, $value) = @_;
	$self->{_delegatee} = $value if defined($value);
	return $self->{_delegatee};
}

sub getDelegatee {
	my ( $self ) = @_;
	return $self->{_delegatee};
}

# get-set method for _publicKey
sub setPublicKey {
	my ( $self, $value) = @_;
	$self->{_publicKey} = $value if defined($value);
	return $self->{_publicKey};
}

sub getPublicKey {
	my ( $self ) = @_;
	return $self->{_publicKey};
}

# get-set method for _stakedAmount
sub setStakedAmount {
	my ( $self, $value) = @_;
	$self->{_stakedAmount} = $value if defined($value);
	return $self->{_stakedAmount};
}

sub getStakedAmount {
	my ( $self ) = @_;
	return $self->{_stakedAmount};
}

# This function parse the JsonObject (taken from server RPC method call) to JsonDelegator object
sub fromJsonObjectToJsonDelegator {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::JsonDelegator();
	$ret->setBondingPurse($json->{'bonding_purse'});
	$ret->setDelegatee($json->{'delegatee'});
	$ret->setPublicKey($json->{'public_key'});
	$ret->setStakedAmount($json->{'staked_amount'});
	return $ret;
}
1;