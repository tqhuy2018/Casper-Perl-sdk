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

=comment
This function serialize String
Rule for the serialization:
if the string is blank, return "00000000"
if the string is not empty, then first get the length of the string, get the prefix = U32.Serialize(string.length)
travel through the string, get each character and get each character ansi code, for example H will get value 72
e will get value 101, o will get value 111, W get value 87
These value will be turn to Hexa value, then "H" will be 72 in ansi and then 48 in Hexa
"e" will be 101 in ansi and then 65 in Hexa
"W" will be 87 in ansi and then 57 in Hexa
"," will be 44 in ansi and then 2c in Hexa
"o" will be 111 in ansi and then 6f in Hexa
The returned value will be the concatenation of the Hexa value over the ansi code for each character of the input String
For example input string is "HeW,o" then the output will be "72652c6f"
Final output will be U32.Serialize(string.length) + Hexa(String.ansi code)
For example input string is "HeW,o" then the output will be "72652c6f", with String length is 5, U32.serialize(5) = "05000000"
Then the String.serialization("HeW,o") = "0500000072652c6f"
=cut
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
		my $oneChar = substr $strToParse,$i,1;
		my $charCode = ord($oneChar);
		my $oneCharSerialize = $numberSerialize->serializeForU8($charCode);
		$ret = $ret.$oneCharSerialize;
	}
	return $ret;
}
# This function serialize  CLValue of type  Unit, just return empty string
sub serializeFromCLParseUnit {
	return "";
}

=comment
This function serialize  CLValue of type  Key
Rule for serialization:
For type of account hash: "00" + value drop the prefix "account-hash-"
For type hash: "01" + value drop the prefix "hash-"
For type URef: same like CLValue of CLType URef serialization
Sample value and serialization:
For URef
"uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007" will has the serialization with value
"02be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607"
For Account
"account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269" will has the serialization with value
"00d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269"
For Hash
"hash-8cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401" will has the serialization with value
"018cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401"
=cut
sub serializeFromCLParseKey {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $value = $clParsed->getItsValueStr();
	my $littlestring = "account-hash-";
	my @matches = $value =~ /($littlestring)/g;
	my $count = @matches;
	if($count == 1) {
		my $strLength = length($value) - 13;
		my $ret = substr $value,13, $strLength;
		$ret = "00".$ret;
		return $ret;
	}
 	$littlestring = "hash-";
	my @matches2 = $value =~ /($littlestring)/g;
	$count = @matches2;
	if($count == 1) {
		my $strLength = length($value) - 5;
		my $ret = substr $value,5, $strLength;
		$ret = "01".$ret;
		return $ret;
	}
	$littlestring = "uref-";
	my @matches3 = $value =~ /($littlestring)/g;
	$count = @matches3;
	if($count == 1) {
		my $strLength = length($value) - 9;
		my $suffix = substr $value,$strLength + 7,2;
		my $ret = substr $value,5, $strLength;
		$ret = "02".$ret.$suffix;
		return $ret;
	}
	return $Common::ConstValues::INVALID_VALUE;
}
=comment
This function serialize  CLValue of type  URef
Sample serialization for value : uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007
Return result will be be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607
=cut
sub serializeFromCLParseURef {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $value = $clParsed->getItsValueStr();
	my $littlestring = "uref-";
	my @matches3 = $value =~ /($littlestring)/g;
	$count = @matches3;
	if($count == 1) {
		my $strLength = length($value) - 9;
		my $suffix = substr $value,$strLength + 7,2;
		my $ret = substr $value,5, $strLength;
		$ret = "02".$ret.$suffix;
		return $ret;
	}
	return $Common::ConstValues::INVALID_VALUE;
}

# This function serialize  CLValue of type  PublicKey, just return the PublicKey value
sub serializeFromCLParsePublicKey {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	return $clParsed->getItsValueStr();
}
# This function serialize  CLValue of type  ByteArray,, simply return the ByteArray value
sub serializeFromCLParseByteArray {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	return $clParsed->getItsValueStr();
}
=comment
This function serialize  CLValue of type  Option
Rule for Option serialization:
If the value inside the Option is Null, return "00"
else return "01" + (Option.inner parse value).serialization
=cut
sub serializeFromCLParseOption {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	if($clParsed->getItsValueStr() eq $Common::ConstValues::NULL_VALUE) {
		return "00";
	}
	my $clParsedInner1 = new CLValue::CLParse();
	$clParsedInner1 = $clParsed->getInnerParse1();
	my $innerParsedSerialization = serializeFromCLParse("0",$clParsedInner1);
	return "01".$innerParsedSerialization;
}
=comment
This function serialize  CLValue of type  List
The rule is:
If the List is empty, just return empty string ""
If the List is not empty, then first take the length of the List, let say it totalElement
Get the prefix as U32 Serialization for totalElement: prefix = U32.serialization(totalElement)
Get through the List element from one to one, get the Serialization of each element and concatenate them
Add the prefix to the concatenation from the List element serialization, that the result need to return.
=cut
sub serializeFromCLParseList {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my @listValue = $clParsed->getItsValueList();
	my $totalElement = @listValue;
	if($totalElement == 0) {
		return "";
	}
	my $numberSerialize = new Serialization::NumberSerialize();
	my $ret = $numberSerialize->serializeForU32("$totalElement");
	my @sequence = (0..$totalElement-1);
	for my $i (@sequence) {
		my $clParseI = new CLValue::CLParse();
		$clParseI = $listValue[$i];
		my $clTypeI = new CLValue::CLType();
		$clTypeI = $clParseI->getItsCLType();
		my $oneParsedSerialization = serializeFromCLParse("0",$clParseI);
		$ret = $ret.$oneParsedSerialization;
	}
	return $ret;
}
=comment
This function serialize  CLValue of type  Map, the rule for serialization:
If the map is empty return "00000000"
else
First get the size of the map, then get the U32.serialize of the map size, let call it lengthSerialization
For 1 pair (key,value) the serialization is key.serialization + value.serialization
map.serialization = lengthSerialization +  concatenation of all pair(key,value)
=cut
sub serializeFromCLParseMap {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my @listKey = $clParsed->getInnerParse1()->getItsValueList();
	my @listValue = $clParsed->getInnerParse2()->getItsValueList();
	my $totalElement = @listKey;
	if($totalElement == 0) {
		return "00000000";
	}
	my $numberSerialize = new Serialization::NumberSerialize();
	my $ret = $numberSerialize->serializeForU32("$totalElement");
	my @sequence = (0..$totalElement-1);
	for my $i (@sequence) {
		my $clParseI = new CLValue::CLParse();
		my $clParseKey = new CLValue::CLType();
		$clParseKey = $listKey[$i];
		$clTypeKey = $clParseKey->getItsCLType();
		my $oneParsedSerialization = serializeFromCLParse("0",$clParseKey);
		my $clParseValue = new CLValue::CLType();
		$clParseValue = $listValue[$i];
		$clTypeValue = $clParseValue->getItsCLType();
		my $keySerialization = serializeFromCLParse("0",$clParseKey);
		my $valueSerialization = serializeFromCLParse("0",$clParseValue);
		$ret = $ret.$keySerialization.$valueSerialization;
	}
	return $ret;
}
=comment
This function serialize  CLValue of type  Result, the rule is:
If the result is Ok, then the prefix = "01"
If the result is Err, then the prefix = "00"
result = prefix + (inner CLParse value).serialized
=cut
sub serializeFromCLParseResult {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $prefix = "";
	if($clParsed->getItsValueStr() eq $Common::ConstValues::CLPARSED_RESULT_OK) {
		$prefix =  "01";
	} elsif($clParsed->getItsValueStr() eq $Common::ConstValues::CLPARSED_RESULT_ERR) {
		$prefix =  "00";
	}
	my $clParsedInner1 = new CLValue::CLParse();
	$clParsedInner1 = $clParsed->getInnerParse1();
	my $innerParsedSerialization = serializeFromCLParse("0",$clParsedInner1);
	return $prefix.$innerParsedSerialization;
}

# This function serialize  CLValue of type  Tuple1, the result is the serialization of the CLParse inner value in the Tuple1
sub serializeFromCLParseTuple1 {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $clParsedInner1 = new CLValue::CLParse();
	$clParsedInner1 = $clParsed->getInnerParse1();
	my $innerParsedSerialization = serializeFromCLParse("0",$clParsedInner1);
	return $innerParsedSerialization;
}

# This function serialize  CLValue of type  Tuple2,  the result is the concatenation of 2 inner CLParse values in the Tuple2

sub serializeFromCLParseTuple2 {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $clParsedInner1 = new CLValue::CLParse();
	$clParsedInner1 = $clParsed->getInnerParse1();
	my $innerParsedSerialization1 = serializeFromCLParse("0",$clParsedInner1);
	my $clParsedInner2 = new CLValue::CLParse();
	$clParsedInner2 = $clParsed->getInnerParse2();
	my $innerParsedSerialization2 = serializeFromCLParse("0",$clParsedInner2);
	return $innerParsedSerialization1.$innerParsedSerialization2;
}

# This function serialize  CLValue of type  Tuple3, the result is the concatenation of 3 inner CLParse values in the Tuple3
   
sub serializeFromCLParseTuple3 {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $clParsedInner1 = new CLValue::CLParse();
	$clParsedInner1 = $clParsed->getInnerParse1();
	my $innerParsedSerialization1 = serializeFromCLParse("0",$clParsedInner1);
	my $clParsedInner2 = new CLValue::CLParse();
	$clParsedInner2 = $clParsed->getInnerParse2();
	my $innerParsedSerialization2 = serializeFromCLParse("0",$clParsedInner2);
	my $clParsedInner3 = new CLValue::CLParse();
	$clParsedInner3 = $clParsed->getInnerParse3();
	my $innerParsedSerialization3 = serializeFromCLParse("0",$clParsedInner3);
	return $innerParsedSerialization1.$innerParsedSerialization2.$innerParsedSerialization3;
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
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING) {
		return serializeFromCLParseString($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UNIT) {
		return serializeFromCLParseUnit($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_KEY) {
		return serializeFromCLParseKey($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UREF) {
		return serializeFromCLParseURef($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_PUBLIC_KEY) {
		return serializeFromCLParsePublicKey($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_BYTEARRAY) {
		return serializeFromCLParseByteArray($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_ANY) {
		return $Common::ConstValues::PURE_NULL;
	}
	return $Common::ConstValues::INVALID_VALUE;
}
# Function for the serialization of  CLParse compound in type with recursive CLValue inside, 
# such as List, Map, Tuple1, Tuple2, Tuple3, Option, Result ....
      
sub serializeFromCLParseCompound {
	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $clType = new CLValue::CLType();
	$clType = $clParsed->getItsCLType();
 	if($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_OPTION) {
		return serializeFromCLParseOption($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_LIST) {
		return serializeFromCLParseList($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_MAP) {
		return serializeFromCLParseMap($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT) {
		return serializeFromCLParseResult($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_TUPLE1) {
		return serializeFromCLParseTuple1($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_TUPLE2) {
		return serializeFromCLParseTuple2($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_TUPLE3) {
		return serializeFromCLParseTuple3($clParsed);
	}
}
=comment
Serialize for CLParse in general
The flow is:
If the CLParse is of type Primitive, such as Bool, U8, U32 ... - CLParse that does not contain recursive type inside it, then call  function
serializeFromCLParsePrimitive to get the CLParse serialization value.
If the CLParse is of type Compound, such as List, Option, Map ... - CLParse that contains recursive type inside it, then call  function
serializeFromCLParseCompound to get the CLParse serialization value.
=cut
sub serializeFromCLParse {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[1];
	my $clType = new CLValue::CLType();
	$clType = $clParsed->getItsCLType();
	if($clType->isCLTypePrimitive()) {
		return serializeFromCLParsePrimitive($clParsed);
	} else {
		serializeFromCLParseCompound($clParsed);
	}
}
1;