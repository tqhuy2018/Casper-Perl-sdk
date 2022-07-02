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
	return "Key".$Common::ConstValues::INVALID_VALUE;
}
=comment
This function serialize  CLValue of type  URef
Sample serialization for value : uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007
Return result will be be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607
=cut
sub serializeFromCLParseURef {
	
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
		print("ABout to serialize of tyep Key");
		return serializeFromCLParseKey($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UREF) {
		return serializeFromCLParseURef($clParsed);
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