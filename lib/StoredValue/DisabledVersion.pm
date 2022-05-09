# Class built for storing DisabledVersion information
package StoredValue::DisabledVersion;
sub new {
	my $class = shift;
	my $self = {
		_contractVersion => shift,
		_protocolVersionMajor => shift,
	};
	bless $self, $class;
	return $self;
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
# This function parse the JsonObject (taken from server RPC method call) to get the DisabledVersion object
sub fromJsonObjectToDisabledVersion {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::DisabledVersion();
	$ret->setContractVersion($json->{'contract_version'});
	$ret->setProtocolVersionMajor($json->{'protocol_version_major'});
	return $ret;
}
1;