=comment
This class provides the serialization for CLType object
=cut

use CLValue::CLParse;
use CLValue::CLType;
use Common::ConstValues;
use Serialization::NumberSerialize;

package Serialization::CLParseSerialization;


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
 
 # Serialization for Bool parsed value
 sub serializeFromCLParseBool {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	if($clParsed->getItsValueStr() eq "true") {
		return "01"
	} elsif($clParsed->getItsValueStr() eq "false") {
		return "00"
	} else {
		return $Common::ConstValues::INVALID_VALUE;
	}
 }
 # Serialization for U8 parsed value
 sub serializeFromCLParseU8 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForU8($clParsed->getItsValueStr());
 }
 # Serialization for U32 parsed value
 sub serializeFromCLParseU32 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForU32($clParsed->getItsValueStr());
 }
 # Serialization for U64 parsed value
 sub serializeFromCLParseU64 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForU64($clParsed->getItsValueStr());
 }
 
=comment
        Serialize for CLValue of CLType U128 or U256 or U512, ingeneral the input value is called Big number
        - Parameters: value of big number  with decimal value in String format
        - Returns: Serialization for the big number, with this rule:
        - Get the hexa value from the  the decimal big number - let call it the main serialization
        - Get the length of the hexa value
        -First byte is the u8 serialization of the length, let call it prefix
        Return result = prefix + main serialization
        Special case: If input = "0" then output = "00"
        This function just call the NumberSerialize class method to get the result, the actual code is implemented in NumberSerialize class
=cut
sub serializeFromCLParseBigNumber {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForBigNumber($clParsed->getItsValueStr());
}
 
=comment
Serialize for CLValue of CLType Int32
        - Parameters:Int32 value in String format
        - Returns: Serialization of UInt32 if input >= 0.
        If input < 0 Serialization of UInt32.max complement to the input
        This function just call the NumberSerialize class method to get the result, the actual code is implemented in NumberSerialize class
=cut
sub serializeFromCLParseI32 {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForI32($clParsed->getItsValueStr());
}
=comment
 Serialize for CLValue of CLType Int64
        - Parameters:Int64 value in String format
        - Returns: Serialization of UInt64 if input >= 0.
        If input < 0 Serialization of UInt64.max complement to the input
        This function just call the NumberSerialize class method to get the result, the actual code is implemented in NumberSerialize class
=cut
sub serializeFromCLParseI64 {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForI64($clParsed->getItsValueStr());
}

# This function serialize String
sub serializeFromCLParseString {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	if($clParsed->getItsValueStr() eq "") {
		return "00000000";
	}
	my $ret = "";
	my $strToParse = $clParsed->getItsValueStr();
	my $strLength = length($strToParse);
	my $numberSerialize = new Serialization::NumberSerialize();
	$ret = $numberSerialize->serializeForU32("$strLength");
	my $maxForLoop = $strLength  - 1;
	my @sequence = (0..$maxForLoop);
	for my $i (@sequence) {
		
	}
}
 # Function for the serialization of  CLParse primitive in type with no recursive CLValue inside, such as Bool, U8, U32, I32, String, ....
 # input: a clParse object
 # output: String represents the serialization of the clParse
 sub serializeFromCLParsePrimitive {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $clType = new CLValue::CLType();
	$clType = $clParsed->getItsCLType();
	if($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_BOOL) {
		return serializeFromCLParseBool($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U8) {
		return serializeFromCLParseU8($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_I32) {
		return serializeFromCLParseI32($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_I64) {
		return serializeFromCLParseI64($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U32) {
		return serializeFromCLParseU32($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U64) {
		return serializeFromCLParseU64($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U128) {
		return serializeFromCLParseBigNumber($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U256) {
		return serializeFromCLParseBigNumber($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U512) {
		return serializeFromCLParseBigNumber($clParsed);
	} 
	return $Common::ConstValues::INVALID_VALUE;
 }

 sub serializeFromCLParseCompound {
 	
 }
 sub serializeFromCLParse {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[1];
	my $clType = new CLValue::CLType();
	$clType = $clParsed->getItsCLType();
	if($clType->isCLTypePrimitive()) {
		print("Serialize for cltype primitive\n");
		return serializeFromCLParsePrimitive($clParsed);
	} else {
		print("Serialize for cltype compound");
		serializeFromCLParseCompound($clParsed);
	}
	 
 }
 1;