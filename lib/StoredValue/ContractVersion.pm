# Class built for storing ContractVersion information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the ContractVersion object
package StoredValue::ContractVersion;
sub new {
	my $class = shift;
	my $self = {
		_contractHash => shift,
		_contractVersion => shift,
		_protocolVersionMajor => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _contractHash
sub setContractHash {
	my ( $self, $value) = @_;
	$self->{_contractHash} = $value if defined($value);
	return $self->{_contractHash};
}

sub getContractHash {
	my ( $self ) = @_;
	return $self->{_contractHash};
}

# get-set method for _contractVersion
sub setContractVersion {
	my ( $self, $value) = @_;
	$self->{_contractVersion} = $value if defined($value);
	return $self->{_contractVersion};
}

sub getContractVersion {
	my ( $self ) = @_;
	return $self->{_contractVersion};
}

# get-set method for _protocolVersionMajor
sub setProtocolVersionMajor {
	my ( $self, $value) = @_;
	$self->{_protocolVersionMajor} = $value if defined($value);
	return $self->{_protocolVersionMajor};
}

sub getProtocolVersionMajor {
	my ( $self ) = @_;
	return $self->{_protocolVersionMajor};
}

# This function parse the Json object (taken from server RPC method call) to get the ContractVersion object
sub fromJsonObjectToContractVersion {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::DisabledVersion();
	$ret->setContractHash($json->{'contract_hash'});
	$ret->setContractVersion($json->{'contract_version'});
	$ret->setProtocolVersionMajor($json->{'protocol_version_major'});
	return $ret;
}
1;