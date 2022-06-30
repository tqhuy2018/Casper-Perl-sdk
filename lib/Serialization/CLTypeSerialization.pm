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
		my $innerCLTypeSerialization = serializeForCLType($clType->getInnerCLType1());
		return "0d".$innerCLTypeSerialization;
	}
	return "---00---";
}
1;