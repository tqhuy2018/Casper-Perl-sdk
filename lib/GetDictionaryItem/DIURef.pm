# Class built for storing DictionaryIdentifier enum type of URef information 
package GetDictionaryItem::DIURef;
sub new {
	my $class = shift;
	my $self = {
		_seedUref => shift,
		_dictionaryItemKey => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _seedUref
sub setSeedUref {
	my ( $self, $value) = @_;
	$self->{_seedUref} = $value if defined($value);
	return $self->{_seedUref};
}

sub getSeedUref {
	my ( $self ) = @_;
	return $self->{_seedUref};
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