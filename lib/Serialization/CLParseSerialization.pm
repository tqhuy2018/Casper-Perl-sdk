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
 sub serializeFromCLParseU8 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForU8($clParsed->getItsValueStr());
 }
 sub serializeFromCLParseU32 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[0];
	my $numberSerialize = new Serialization::NumberSerialize();
	print("Value u32 is: ".$clParsed->getItsValueStr()."\n");
	return $numberSerialize->serializeForU32($clParsed->getItsValueStr());
 }
 sub serializeFromCLParseU64 {
 	my @list = @_;
	my $clParsed = new CLValue::CLParse();
	$clParsed = $list[1];
	my $numberSerialize = new Serialization::NumberSerialize();
	return $numberSerialize->serializeForU64($clParsed->getItsValueStr());
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
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U32) {
		print("Serialize for U32\n");
		return serializeFromCLParseU32($clParsed);
	} elsif ($clType->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U64) {
		return serializeFromCLParseU64($clParsed);
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