=comment
This class provides the serialization for number from U8 to U512
=cut

use Common::ConstValues;
use Serialization::QuotientNRemainder;

package Serialization::NumberSerialize;


#constructor
sub new {
	my $class = shift;
	my $self = {
			};
	bless $self, $class;
	return $self;
}
sub serializeForU8 {
	my @list = @_;
	my $valueInStr = $list[1];
	if($valueInStr eq "0") {
		return "00";
	} 
	my $value = int($valueInStr);
	if($value < 10) {
		return "0".$valueInStr;
	} else {
		my $remainder = $value % 16;
		my $quotient = ($value - $remainder) / 16;
		my $remainderStr = from10To16("0",$remainder);
		my $quotientStr = from10To16("0",$quotient);
		return $quotientStr.$remainderStr;
	}
	return $Common::ConstValues::INVALID_VALUE;
}
sub serializeForU32 {
	my @list = @_;
	my $valueInStr = $list[1];
	if($valueInStr eq "0") {
		return "00000000";
	}
	
}
sub fromDecimalStringToHexaString {
	
}
sub findQuotientAndRemainderOfStringNumber {
	my @list = @_;
	my $fromNumberInStr = int($list[1]);
	my $retQNR = new Serialization::QuotientNRemainder();
	my $ret;
	my $strLength = length($fromNumberInStr);
}
sub from10To16 {
	my @list = @_;
	my $number = int($list[1]);
	if($number < 10){
		return "$number"
	} elsif ($number == 10) {
		return "a"
	} elsif ($number == 11) {
		return "b"
	} elsif ($number == 12) {
		return "c"
	} elsif ($number == 13) {
		return "d"
	} elsif ($number == 14) {
		return "e"
	} elsif ($number == 15) {
		return "f"
	} else {
		return $Common::ConstValues::INVALID_VALUE;
	}
}
1;