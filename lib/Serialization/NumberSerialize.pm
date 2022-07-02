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
# Function for the serialization of unsigned number u8
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
# Function for the serialization of unsigned number u32
sub serializeForU32 {
	my @list = @_;
	my $valueInStr = $list[1];
	if($valueInStr eq "0") {
		return "00000000";
	}
	my $ret = fromDecimalStringToHexaString($valueInStr);
	my $retLength = length($ret);
	if($retLength < 8) {
		my $total0Added = 8 - $retLength - 1;
		my $prefix0 = "";
		my @sequence = (0..$total0Added);
		for my $i (@sequence) {
			$prefix0 = $prefix0."0";
		}
		$ret = $prefix0.$ret;
	}
	my $realRet = stringReversed2Digit($ret);
	return $realRet;
}
# Function for the serialization of unsigned number u64
sub serializeForU64 {
	my @list = @_;
	my $valueInStr = $list[1];
	if($valueInStr eq "0") {
		return "0000000000000000";
	}
	my $ret = fromDecimalStringToHexaString($valueInStr);
	my $retLength = length($ret);
	if($retLength < 16) {
		my $total0Added = 16 - $retLength - 1;
		my $prefix0 = "";
		my @sequence = (0..$total0Added);
		for my $i (@sequence) {
			$prefix0 = $prefix0."0";
		}
		$ret = $prefix0.$ret;
	}
	my $realRet = stringReversed2Digit($ret);
	return $realRet;
}
=comment
Serialize for CLValue of CLType Int32
        - Parameters:Int32 value
        - Returns: Serialization of UInt32 if input >= 0.
        If input < 0 Serialization of UInt32.max complement to the input
=cut
sub serializeForI32 {
	my @list = @_;
	my $numberInStr = $list[1];
	my $firstChar = substr $numberInStr,0,1;
	if($firstChar eq "-") {
		my $strLength = length($numberInStr);
		my $numberValueStr = substr $numberInStr,1,$strLength-1;
		my $numberValue = int($numberValueStr);
		my $remain = 4294967295 - $numberValue + 1;
		return serializeForU32("0",$remain);
	} else {
		return serializeForU32("0",$numberInStr);
	}
}
=comment 
 Serialize for CLValue of CLType Int64
        - Parameters:Int64 value in String format
        - Returns: Serialization of UInt64 if input >= 0.
        If input < 0 Serialization of UInt64.max complement to the input
=cut 
sub serializeForI64 {
	my @list = @_;
	my $numberInStr = $list[1];
	my $firstChar = substr $numberInStr,0,1;
	if($firstChar eq "-") {
		print("I64 for minus number".$numberInStr."\n");
		my $strLength = length($numberInStr);
		my $numberValueStr = substr $numberInStr,1,$strLength-1;
		my $numberValue = int($numberValueStr);
		my $remain = 18446744073709551615 - $numberValue + 1;
		return serializeForU64("0",$remain);
	} else {
		print("Serialize I64 for ".$numberInStr."\n");
		return serializeForU64("0",$numberInStr);
	}
}
sub serializeForBigNumber {
	my @list = @_;
	my $valueInStr = $list[1];
	if($valueInStr eq "0") {
		return "00";
	}
	my $ret = fromDecimalStringToHexaString($valueInStr);
	my $retLength = length($ret);
	my $bytes = 0;
	if($retLength % 2  == 1) {
		$ret = "0".$ret;
		$bytes = ($retLength + 1 )/2;
	}  else {
		$bytes = $retLength/2;
	}
	my $prefix = serializeForU8("0","$bytes");
	my $realRet = stringReversed2Digit($ret);
	$realRet = $prefix.$realRet;
	return $realRet;
	
}
sub fromDecimalStringToHexaString {
	my @list = @_;
	my $fromNumberInStr = $list[0];
	my $ret = "";
	my $ret1 = findQuotientAndRemainderOfStringNumber($fromNumberInStr);
	my $bigNumber = $ret1->getQuotient();
	my $numberLength = length($bigNumber);
	my $remainderStr = from10To16("0",$ret1->getRemainder());
	$ret = $remainderStr;
	my $lastQuotient = "";
	if($numberLength < 2) {
		$lastQuotient = $ret1->getQuotient();
	}
	while($numberLength >= 2) {
		my $retN = new Serialization::QuotientNRemainder();
		$retN = findQuotientAndRemainderOfStringNumber($bigNumber);
		$numberLength = length($retN->getQuotient());
		$bigNumber = $retN->getQuotient();
		$remainderStr = from10To16("0",$retN->getRemainder());
		$ret = $ret.$remainderStr;
		$lastQuotient = $retN->getQuotient();
	}
	if($lastQuotient eq "0") {
		
	} else {
		$ret = $ret.$lastQuotient;
	}
	# my $realRet = stringReversed($ret);
	my $realRet = reverse($ret);
	#my $retLength = length($realRet);
	#if($retLength % 2 == 1) {
	#	$realRet = "0".$realRet;
	#}
	return $realRet;
}

sub stringReversed2Digit {
	my @list = @_;
	my $fromString = $list[0];
	my $ret = "";
	my $charIndex = length($fromString);
	while($charIndex > 0) {
		$charIndex = $charIndex - 2;
		my $subStr = substr $fromString, $charIndex,2;
		$ret = $ret.$subStr;
	}
	return $ret;
	
}
sub findQuotientAndRemainderOfStringNumber {
	my @list = @_;
	my $fromNumberInStr = $list[0];
	my $value = int($fromNumberInStr);
	my $retQNR = new Serialization::QuotientNRemainder();
	my $ret = "";
	my $strLength = length($fromNumberInStr);
	my $startIndex = 0;
	my $remainder = 0;
	my $quotient = 0;
	if($strLength < 2) {
		$retQNR->setQuotient("0");
		$retQNR->setRemainder("$value");
		return $retQNR;
	} elsif($strLength == 2) {
		$remainder = $value % 16;
	    $quotient = ($value - $remainder) / 16;
		$retQNR->setRemainder("$remainder");
		$retQNR->setQuotient("$quotient");
		return $retQNR;
	} else {
		#$startIndex = 2;
		my $first2Char = substr $fromNumberInStr,0,2;
		my $value2 = int($first2Char);
		if($value2 < 16) {
			$startIndex = 3;
			my $first3Char = substr $fromNumberInStr, 0, 3;
			my $value3 = int($first3Char);
			$remainder = $value3 % 16;
			$quotient = ($value3 - $remainder) / 16;
			$ret = from10To16("0",$quotient);
		} else {
			$startIndex = 2;
			$remainder = $value2 % 16;
			$quotient = ($value2 - $remainder) / 16;
			$ret = from10To16("0",$quotient);
		}
		while($startIndex < $strLength) {
			my $nextChar =  substr $fromNumberInStr, $startIndex,  1;
			my $nextValue = $remainder * 10 +  int($nextChar);
			if($nextValue < 16) {
				if($startIndex + 2 <= $strLength) {
					$ret = $ret."0";
					my $nextChar2 = substr $fromNumberInStr, $startIndex,  2;
					$nextValue = $remainder  * 100 + int($nextChar2);
					$remainder = $nextValue % 16;
					my $quotient2 = ($nextValue - $remainder) / 16;
					my $nextCharInRet = from10To16("0",$quotient2);
					$ret = $ret.$nextCharInRet;
					$startIndex = $startIndex + 2;
				} else {
					my $remainChar = $strLength - $startIndex;
					if($remainChar == 1) {
						$ret = $ret."0";
					} elsif($remainChar == 2) {
						$ret = $ret."00";
					}
					$remainder = $nextValue;
					$strLength = 0;
				}
			} else {
				$remainder = $nextValue % 16;
				my $quotient2 = ($nextValue - $remainder) / 16;
				my $nextCharInRet = from10To16("0",$quotient2);
				$ret = $ret.$nextCharInRet;
				$startIndex = $startIndex + 1;
			}
		}
	}
	$retQNR->setRemainder($remainder);
	$retQNR->setQuotient($ret);
	return $retQNR;
	
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