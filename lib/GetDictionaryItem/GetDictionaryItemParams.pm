# Class built for storing GetDictionaryItemParams, used to generate the parameter for state_get_dictionary_item RPC call
package GetDictionaryItem::GetDictionaryItemParams;
sub new {
	my $class = shift;
	my $self = {
		_stateRootHash => shift,
		_dictionaryIdentifier => shift,
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

# get-set method for _dictionaryIdentifier
sub setDictionaryIdentifier {
	my ( $self, $value) = @_;
	$self->{_dictionaryIdentifier} = $value if defined($value);
	return $self->{_dictionaryIdentifier};
}

sub getDictionaryIdentifier {
	my ( $self ) = @_;
	return $self->{_dictionaryIdentifier};
}

=comment
This function generate the parameter for the post method of the state_get_dictionary_item RPC call
Base on the type of the DictionaryIdentifier, corresponding Json string will be generate.
For example if the DictionaryIdentifier is of type Dictionary, the the generated Json string for this function is somehow like this:
{"method" : "state_get_dictionary_item", "id" :  1, "params" : {"state_root_hash" :  "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8", "dictionary_identifier": {"Dictionary": "dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373"}}, "jsonrpc" :  "2.0"}
If the DictionaryIdentifier is of type AccountNamedKey, the the generated Json string for this function is somehow like this:
{"method" : "state_get_dictionary_item","id" : 1,"params" :{"state_root_hash" : "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8","dictionary_identifier":{"AccountNamedKey":{"dictionary_name":"dict_name","key":"account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877","dictionary_item_key":"abc_name"}}},"jsonrpc" : "2.0"}
=cut
sub generateParameterStr {
	my ($self) = @_;
	my $di = $self->{_dictionaryIdentifier};
	my $diType = $di->getItsType();
	my $diValue = $di->getItsValue();
	my $ret = "";
	if($diType eq "AccountNamedKey") {
		$ret = '{"method" : "'.$Common::ConstValues::RPC_GET_DICTIONARY_ITEM.'", "id" :  1, "params" : {"state_root_hash" :  "'.$self->{_stateRootHash}.'", "dictionary_identifier": {"AccountNamedKey": {"dictionary_name": "'.$diValue->getDictionaryName().'", "key": "'.$diValue->getKey().'", "dictionary_item_key": "'.$diValue->getDictionaryItemKey().'"}}}, "jsonrpc" :  "2.0"}';
	} elsif ($diType eq "ContractNamedKey") {
		$ret = '{"method" : "'.$Common::ConstValues::RPC_GET_DICTIONARY_ITEM.'", "id" :  1, "params" : {"state_root_hash" :  "'.$self->{_stateRootHash}.'", "dictionary_identifier": {"ContractNamedKey": {"dictionary_name": "'.$diValue->getDictionaryName().'", "key": "'.$diValue->getKey().'", "dictionary_item_key": "'.$diValue->getDictionaryItemKey().'"}}}, "jsonrpc" :  "2.0"}';
	} elsif ($diType eq "URef") {
		$ret =  '{"method" : "'.$Common::ConstValues::RPC_GET_DICTIONARY_ITEM.'", "id" :  1, "params" : {"state_root_hash" :  "'.$self->{_stateRootHash}.'", "dictionary_identifier": {"URef": {"seed_uref": "'.$diValue->getSeedUref().'", "dictionary_item_key": "'.$diValue->getDictionaryItemKey().'"}}}, "jsonrpc" :  "2.0"}';
	} elsif ($diType eq "Dictionary") {
		$ret =  '{"method" : "'.$Common::ConstValues::RPC_GET_DICTIONARY_ITEM.'", "id" :  1, "params" : {"state_root_hash" :  "'.$self->{_stateRootHash}.'", "dictionary_identifier": {"Dictionary": "'.$diValue->getItsValue().'"}}, "jsonrpc" :  "2.0"}';
	}
	return $ret;
}
1;
