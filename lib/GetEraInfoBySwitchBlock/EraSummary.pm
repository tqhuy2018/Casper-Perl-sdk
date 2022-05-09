# Class built for storing EraSummary information
# This class hold the stored value,  which can be 1 among 10 possible value in this enum,  defined at this address
# https: //docs.rs/casper-node/latest/casper_node/types/json_compatibility/enum.StoredValue.html
package GetEraInfoBySwitchBlock::EraSummary;
use StoredValue::StoredValue;
sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_eraId => shift,
		_storedValue => shift, 
		_stateRootHash => shift, 
		_merkleProof => shift, 
	};
	bless $self, $class;
	return $self;
}

# get-set method for _blockHash
sub setBlockHash {
	my ( $self, $value) = @_;
	$self->{_blockHash} = $value if defined($value);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}

# get-set method for _eraId
sub setEraId {
	my ( $self, $value) = @_;
	$self->{_eraId} = $value if defined($value);
	return $self->{_eraId};
}

sub getEraId {
	my ( $self ) = @_;
	return $self->{_eraId};
}

# get-set method for _storedValue
sub setStoredValue {
	my ( $self, $value) = @_;
	$self->{_storedValue} = $value if defined($value);
	return $self->{_storedValue};
}

sub getStoredValue {
	my ( $self ) = @_;
	return $self->{_storedValue};
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
# This function parse the JsonObject (taken from server RPC method call) to generate the EraSummary object
sub fromJsonToEraSummary {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetEraInfoBySwitchBlock::EraSummary();
	$ret->setBlockHash($json->{'block_hash'});
	$ret->setEraId($json->{'era_id'});
	$ret->setStateRootHash($json->{'state_root_hash'});
	$ret->setMerkleProof($json->{'merkle_proof'});
	$ret->setBlockHash($json->{'block_hash'});
	my $storedValue = StoredValue::StoredValue->fromJsonObjectToStoredValue($json->{'stored_value'});
	$ret->setStoredValue($storedValue);
	return $ret;
}
1;