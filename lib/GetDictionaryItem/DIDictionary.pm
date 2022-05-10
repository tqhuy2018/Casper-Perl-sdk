# Class built for storing DictionaryIdentifier enum type of Dictionary information 
package GetDictionaryItem::DIDictionary;
sub new {
	my $class = shift;
	my $self = {
		_itsValue => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsValue
sub setItsValue {
	my ( $self, $value) = @_;
	$self->{_itsValue} = $value if defined($value);
	return $self->{_itsValue};
}

sub getItsValue {
	my ( $self ) = @_;
	return $self->{_itsValue};
}
1;