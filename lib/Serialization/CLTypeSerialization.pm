=comment
This class provides the serialization for CLType object
=cut

use CLValue::CLType;

package Serialization::CLTypeSerialization;



#constructor
sub new {
	my $class = shift;
	my $self = {
			};
	bless $self, $class;
	return $self;
}

 #This function do the serialization for a CLType object
 #Input: a clType object
 #Output: serialization of the CLType object, in String format
 
sub serializeForCLType {
	my @list = @_;
	#my @clType = $list[1] ;
	my $clType = new CLValue::CLType();
	$clType = $list[1];
	print("CLTYPE: " . $clType->getItsTypeStr());
	if($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_BOOL) {
		return "00";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_I32) {
		return "01";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_I64) {
		return "02";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U8) {
		return "03";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U32) {
		return "04";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U64) {
		return "05";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U128) {
		return "06";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U256) {
		return "07";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U512) {
		return "08";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UNIT) {
		return "09";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING) {
		return "0a";
	}  elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_KEY) {
		return "0b";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UREF) {
		return "0c";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_OPTION) {
		my $clInner1 = new CLValue::CLType();
		$clInner1 = $clType->getInnerCLType1();
		my $innerCLTypeSerialization = serializeForCLType("0",$clInner1);
		return "0d".$innerCLTypeSerialization;
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_LIST) {
		my $clInner1 = new CLValue::CLType();
		$clInner1 = $clType->getInnerCLType1();
		my $innerCLTypeSerialization = serializeForCLType("0",$clInner1);
		return "0e".$innerCLTypeSerialization;
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_BYTEARRAY) {
		return "0f";
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT) {
		my $clInner1 = new CLValue::CLType();
		$clInner1 = $clType->getInnerCLType1();
		my $innerCLTypeSerialization1 = serializeForCLType("0",$clInner1);
		my $clInner2 = new CLValue::CLType();
		$clInner2 = $clType->getInnerCLType2();
		my $innerCLTypeSerialization2 = serializeForCLType("0",$clInner1);
		return "10".$innerCLTypeSerialization1.$innerCLTypeSerialization2;
	} elsif($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_MAP) {
		my $clInner1 = new CLValue::CLType();
		$clInner1 = $clType->getInnerCLType1();
		my $innerCLTypeSerialization1 = serializeForCLType("0",$clInner1);
		my $clInner2 = new CLValue::CLType();
		$clInner2 = $clType->getInnerCLType2();
		my $innerCLTypeSerialization2 = serializeForCLType("0",$clInner1);
		return "11".$innerCLTypeSerialization1.$innerCLTypeSerialization2;
	}
	return "---00---";
}
1;