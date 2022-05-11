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


# This function generate the parameter for the post method of the state_get_dictionary_item RPC call
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
