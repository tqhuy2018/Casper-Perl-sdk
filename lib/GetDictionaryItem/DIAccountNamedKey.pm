# Class built for storing DictionaryIdentifier enum type of AccountNamedKey information 
package GetDictionaryItem::DIAccountNamedKey;
sub new {
	my $class = shift;
	my $self = {
		_key => shift,
		_dictionaryName => shift,
		_dictionaryItemKey => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _key
sub setKey {
	my ( $self, $value) = @_;
	$self->{_key} = $value if defined($value);
	return $self->{_key};
}

sub getKey {
	my ( $self ) = @_;
	return $self->{_key};
}

# get-set method for _dictionaryName
sub setDictionaryName {
	my ( $self, $value) = @_;
	$self->{_dictionaryName} = $value if defined($value);
	return $self->{_dictionaryName};
}

sub getDictionaryName {
	my ( $self ) = @_;
	return $self->{_dictionaryName};
}

# get-set method for _dictionaryItemKey
sub setDictionaryItemKey {
	my ( $self, $value) = @_;
	$self->{_dictionaryItemKey} = $value if defined($value);
	return $self->{_dictionaryItemKey};
}

sub getDictionaryItemKey {
	my ( $self ) = @_;
	return $self->{_dictionaryItemKey};
}
1;