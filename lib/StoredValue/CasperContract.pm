#  Class built for storing Contract information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the CasperContract object
package StoredValue::CasperContract;
use StoredValue::EntryPoint;
use GetDeploy::ExecutionResult::Transform::NamedKey;
sub new {
	my $class = shift;
	my $self = {
		_contractPackageHash => shift,
		_contractWasmHash => shift,
		_entryPoints => [ @_ ], # list of EntryPoint object
		_namedKeys => [ @_ ], # list of NamedKey object
		_protocolVersion => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _contractPackageHash
sub setContractPackageHash {
	my ( $self, $value) = @_;
	$self->{_contractPackageHash} = $value if defined($value);
	return $self->{_contractPackageHash};
}

sub getContractPackageHash {
	my ( $self ) = @_;
	return $self->{_contractPackageHash};
}

# get-set method for _contractWasmHash
sub setContractWasmHash {
	my ( $self, $value) = @_;
	$self->{_contractWasmHash} = $value if defined($value);
	return $self->{_contractWasmHash};
}

sub getContractWasmHash {
	my ( $self ) = @_;
	return $self->{_contractWasmHash};
}

# get-set method for _protocolVersion
sub setProtocolVersion {
	my ( $self, $value) = @_;
	$self->{_protocolVersion} = $value if defined($value);
	return $self->{_protocolVersion};
}

sub getProtocolVersion {
	my ( $self ) = @_;
	return $self->{_protocolVersion};
}

# get-set method for _entryPoints
sub setEntryPoints {
	my ( $self, @value) = @_;
	$self->{_entryPoints} = \@value;
	return $self->{_entryPoints};
}

sub getEntryPoints {
	my ( $self ) = @_;
	my @list = @{$self->{_entryPoints}};
	wantarray ? @list : \@list;
}

# get-set method for _namedKeys
sub setNamedKeys {
	my ( $self, @value) = @_;
	$self->{_namedKeys} = \@value;
	return $self->{_namedKeys};
}

sub getNamedKeys {
	my ( $self ) = @_;
	my @list = @{$self->{_namedKeys}};
	wantarray ? @list : \@list;
}
# This function parse the JsonObject (taken from server RPC method call) to get the CasperContract object
sub fromJsonObjectToCasperContract {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::CasperContract();
	$ret->setContractPackageHash($json->{'contract_package_hash'});
	$ret->setContractWasmHash($json->{'contract_wasm_hash'});
	$ret->setProtocolVersion($json->{'protocol_version'});
	# get list EntryPoints
	my @listEPJson = @{$json->{'entry_points'}};
	my $totalEP = @listEPJson;
	if($totalEP > 0) {
		my @listEP = ();
		foreach(@listEPJson) {
			my $oneEP = StoredValue::EntryPoint->fromJsonObjectToEntryPoint($_);
			push(@listEP,$oneEP);
		}
		$ret->setEntryPoints(@listEP);
	}
	
	# get NameKeys
	my @listNKJson = @{$json->{'named_keys'}};
	my $totalNK = @listNKJson;
	if($totalNK > 0) {
		my @listNK = ();
		foreach(@listNKJson) {
			my $oneNK = GetDeploy::ExecutionResult::Transform::NamedKey->fromJsonObjectToNamedKey($_);
			push(@listNK, $oneNK);
		}
		$ret->setNamedKeys(@listNK);
	}
	return $ret;
}
1;
