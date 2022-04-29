=comment
Class built for storing the cl_type value of a CLValue object.
For example take this CLValue object
{
"bytes": "0400e1f505"
"parsed": "100000000"
"cl_type": "U512"
}
Then the CLType will hold the value of U512.
There are some more attributes in the object to store more information in its value, 
used to build   recursived CLType,  such as List,  Map,  Tuple,  Result,  Option
 */
=cut
package CLValue::CLType;

use feature qw(switch);

sub new {
	my $class = shift;
	my $self = {
		# Type of the CLType in String,  can be Bool,  String,  I32,  I64,  List,  Map, ...
		_itsTypeStr => shift, 
		# innerCLType to hold value for the following type: 
    	# Option,  Result,  Tuple1 will take only 1 item:  innerCLType1
    	# Map,  Tuple2 will take 2  item:  innerCLType1, innerCLType2
    	# Tuple3 will take 3 item:  innerCLType1,  innerCLType2,  innerCLType3
		_innerCLTYpe1 => shift, 
		_innerCLTYpe2 => shift, 
		_innerCLTYpe3 => shift, 
	};
	bless $self,$class;
	return $self;
}

#get-set method for itsTypeStr

sub setItsTypeStr {
	my ($self,$clTypeStr) = @_;
	$self->{_itsTypeStr} = $clTypeStr if defined ($clTypeStr);
	return $self->{_itsTypeStr};
}
sub getItsTypeStr {
	my ($self) = @_;
	return $self->{_itsTypeStr};
}

#get-set method for innerCLType1

sub setInnerCLType1 {
	my ($self,$clType1) = @_;
	$self->{_innerCLType1} = $clType1 if defined($clType1);
	return $self->{_innerCLType1};
}

sub getInnerCLType1 {
	my ($self) = @_;
	return $self->{_innerCLType1};
}

#get-set method for innertType2

sub setInnerCLType2 {
	my ($self,$clType2) = @_;
	$self->{_innerCLType2} = $clType2 if defined ($clType2);
	return $self->{_innerCLType2};
}
sub getInnerCLType2 {
	my ($self) = @_;
	return $self->{_innerCLType2};
}

#get-set method for innerCLType3

sub setInnerCLType3 {
	my ($self,$clType3) = @_;
	$self->{_innerCLType3} = $clType3 if defined ($clType3);
	return $self->{_innerCLTYpe3};
}
sub getInnerCLType3 {
	my ($self) = @_;
	return $self->{_innerCLType3};
}

sub isCLTypePrimitive {
	my ($self) = @_;
	if ($self->{_itsTypeStr} eq "Bool") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "I32") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "I64") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U8") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U32") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U64") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U128") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U256") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "U512") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "String") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "Unit") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "Key") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "URef") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "PublicKey") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "ByteArray") {
		return 1;
	} elsif ($self->{_itsTypeStr} eq "Any") {
		return 1;
	} else {
		return 0;
	}
}
1;