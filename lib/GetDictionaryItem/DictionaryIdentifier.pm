=comment
* Class built for storing DictionaryIdentifier enum
 * This enum can have 4 possible values:
 * AccountNamedKey
 * ContractNamedKey
 * Dictionary
 * URef
 * This class has 2 attribute:
 * _itsType: is for the type of the enum, which can be 1 among 4 possible values mentioned above,
 * _itsValue: a mutable list of just 1 element, to hold the real value of each enum type,
 * - Example 1: if the DictionaryIdentifier is of type AccountNamedKey, its values of (key, dictionary_name, dictionary_item_key) 
 * will be stored in DIAccountNamedKey class object, and this object is stored 
 * in this _itsValue variable.
 * - Example 2: if the DictionaryIdentifier is of type URef, its values of (seed_uref, dictionary_item_key) 
 * will be stored in DIURef class object, and this object is stored 
 * in this _itsValue variable.
=cut
package GetDictionaryItem::DictionaryIdentifier;
sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsType
sub setItsType {
	my ( $self, $value) = @_;
	$self->{_itsType} = $value if defined($value);
	return $self->{_itsType};
}

sub getItsType {
	my ( $self ) = @_;
	return $self->{_itsType};
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