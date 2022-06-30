=comment
This class provides the serialization for CLType object
=cut

use CLValue::CLParse;
use Common::ConstValues;

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
	$clParsed = $list[1];
	if($clParsed->getItsValueStr() eq "true") {
		return "01"
	} elsif($clParsed->getItsValueStr() eq "false") {
		return "00"
	} else {
		return $Common::ConstValues::INVALID_VALUE;
	}
 }
 1;