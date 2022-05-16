# Class built for storing AssociatedKey information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the AssociatedKey object
package StoredValue::AssociatedKey;
sub new {
	my $class = shift;
	my $self = {
		_accountHash => shift,
		_weight => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _accountHash
sub setAccountHash {
	my ( $self, $value) = @_;
	$self->{_accountHash} = $value if defined($value);
	return $self->{_accountHash};
}

sub getAccountHash {
	my ( $self ) = @_;
	return $self->{_accountHash};
}

# get-set method for _weight
sub setWeight {
	my ( $self, $value) = @_;
	$self->{_weight} = $value if defined($value);
	return $self->{_weight};
}

sub getWeight {
	my ( $self ) = @_;
	return $self->{_weight};
}

# This function parse the Json object (taken from server RPC method call) to get the AssociatedKey object
sub fromJsonObjectToAssociatedKey {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::AssociatedKey();
	$ret->setAccountHash($json->{'account_hash'});
	$ret->setWeight($json->{'weight'});
	return $ret;
}
1;