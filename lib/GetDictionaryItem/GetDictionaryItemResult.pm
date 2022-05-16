# Class built for storing GetItemResult information, taken from state_get_item RPC method
package GetDictionaryItem::GetDictionaryItemResult;
use StoredValue::StoredValue;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_dictionaryKey=>shift,
		_storedValue => shift, 
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

# get-set method for _dictionaryKey
sub setDictionaryKey {
	my ( $self, $value) = @_;
	$self->{_dictionaryKey} = $value if defined($value);
	return $self->{_dictionaryKey};
}

sub getDictionaryKey {
	my ( $self ) = @_;
	return $self->{_dictionaryKey};
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
 
# This function parse the JsonObject (taken from server RPC method call) to generate the GetDictionaryItemResult object
sub fromJsonToGetDictionaryItemResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDictionaryItem::GetDictionaryItemResult();
	$ret->setApiVersion($json->{'api_version'});
	$ret->setMerkleProof($json->{'merkle_proof'});
	$ret->setDictionaryKey($json->{'dictionary_key'});
	my $storedValue = StoredValue::StoredValue->fromJsonObjectToStoredValue($json->{'stored_value'});
	$ret->setStoredValue($storedValue);
	return $ret;
}
1;