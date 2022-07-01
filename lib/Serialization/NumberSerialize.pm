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
	} else {
		print("In number sserialization, U32 value is: ".$valueInStr."\n");
	}
	my $ret = fromDecimalStringToHexaString($valueInStr);
	
	my $retLength = length($ret);
	print("serializeForU32, ret is:".$ret." and length:".$retLength."\n");
	if($retLength < 8) {
		my $total0Added = 8 - $retLength;
		my $prefix0 = "";
		my @sequence = (0..$total0Added);
		for my $i (@sequence) {
			$prefix0 = $prefix0."0";
		}
		$ret = $prefix0.$ret;
	}
	print("after adding 0, ret is:".$ret."\n");
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
sub fromDecimalStringToHexaString {
	my @list = @_;
	my $fromNumberInStr = $list[0];
	my $ret = "";
	print("in FromDecimal to Hexa, fromNumberInStr:" . $fromNumberInStr."\n");
	my $ret1 = findQuotientAndRemainderOfStringNumber($fromNumberInStr);
	my $bigNumber = $ret1->getQuotient();
	print("in FromDecimal to Hexa, bigNumber:".$bigNumber."\n");
	my $numberLength = length($bigNumber);
	print("in FromDecimal to Hexa, bigNumber length:".$numberLength."\n");
	my $remainderStr = from10To16("0",$ret1->getRemainder());
	print("in FromDecimal to Hexa, remainderStr:".$remainderStr."\n");
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
	my $realRet = stringReversed($ret);
	print("in FromDecimal to Hexa, ret is:".$ret." and realRet is:".$realRet."\n");
	return $realRet;
}
sub stringReversed {
	my @list = @_;
	my $fromString = $list[0];
	my $ret = "";
	print("IN string reversed, from string is:".$fromString."\n");
	my $charIndex = length($fromString);
	while($charIndex > 0) {
		$charIndex --;
		my $subStr = substr $fromString, $charIndex,$charIndex + 1;
		$ret = $ret.$subStr;
		print("subString is:".$subStr." and ret is:".$ret."\n");
	}
	return $ret;
}
sub stringReversed2Digit {
	my @list = @_;
	my $fromString = $list[0];
	my $ret = "";
	my $charIndex = length($fromString);
	while($charIndex > 0) {
		$charIndex = $charIndex - 2;
		my $subStr = substr $fromString, $charIndex,$charIndex + 2;
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
	my $startIndex = 2;
	my $remainder = 0;
	my $quotient = 0;
	if($strLength < 2) {
		$retQNR->setRemainder("0");
		$retQNR->setQuotient("$value");
		return $retQNR;
	} elsif($strLength == 2) {
		$remainder = $value % 16;
	    $quotient = ($value - $remainder) / 16;
		$retQNR->setRemainder("$remainder");
		$retQNR->setQuotient("$quotient");
		return $retQNR;
	} else {
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
			my $nextChar =  substr $fromNumberInStr, $startIndex, $startIndex + 1;
			my $nextValue = $remainder * 10 +  int($nextChar);
			if($nextValue < 16) {
				if($startIndex < $strLength + 2) {
					$ret = $ret."0";
					my $nextChar2 = substr $fromNumberInStr, $startIndex, $startIndex + 2;
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