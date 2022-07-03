=comment
This class provides the serialization for Deploy object
=cut

use CLValue::CLType;
use CLValue::CLParse;
use Common::ConstValues; 
use GetDeploy::DeployHeader;
use Serialization::CLParseSerialization;
package Serialization::DeploySerializeHelper;
use Date::Parse;



#constructor
sub new {
	my $class = shift;
	my $self = {
			};
	bless $self, $class;
	return $self;
}
=comment
Serialization for the Deploy Header
Rule for serialization:
Returned result = deployHeader.account + U64.serialize(deployHeader.timeStampMiliSecondFrom1970InU64) + U64.serialize(deployHeader.ttlMilisecondsFrom1980InU64) + U64.serialize(gas_price) + deployHeader.bodyHash
=cut
sub serializeForHeader {
	my $header = new GetDeploy::DeployHeader();
	my @list = @_;
	$header = $list[1];
	# Serialization for Header.TimeStamp
	my $timeStamp = $header->getTimestamp();
	my $miliseconds = str2time($timeStamp);
	$miliseconds = $miliseconds * 1000;
	print("Milisecond:".$miliseconds."\n");
	my $clParse64 = new CLValue::CLParse();
	my $clType64 = new CLValue::CLType();
	$clType64->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$clParse64->setItsCLType($clType64);
	$clParse64->setItsValueStr("$miliseconds");
	my $parseSerialization = new Serialization::CLParseSerialization();
	$timeStampSerialization = $parseSerialization->serializeFromCLParse($clParse64);
	print("Time stamp serialization is:".$timeStampSerialization."\n");
	print("TTL is:".$header->getTTL()."\n");
	my $ttlSerialization = fromTTLToMiliseconds($header->getTTL());
	my $ret = "";
	return $ret;
}
sub fromTTLToMiliseconds {
	my @list = @_;
	$ttl = $list[0];
	print("Get milisecond for ttl:".$ttl."\n");
	my $findStr = " ";
	my @matches = $ttl =~ /($findStr)/g;
	my $count = @matches;
	my $ret = 0;
	my $numStr = "";
	my $numValue = 0;
	# if ttl is in form of "1h 2m 30s" or "2days 1hour 3minutes 15s"
	if($count > 0) {
		my @sequence =(0..$count-1);
		for my $i (@sequence) {
			my $ret1 = fromTTLToMiliseconds(@matches[$i]);
			$ret = $ret + $ret1;
		}
		return $ret;
	} 
	# if ttl is in form of single date time such as "1h", "30" or "2days"
	else {
		my $ttlStrLength = length($ttl);
		# if ttl is in format "3days" or "10days"
		$findStr = "days";
		my @matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-4;
			$numValue = int($numStr);
			$ret = $numValue * 24 * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "1day"
		$findStr = "day";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-3;
			$numValue = int($numStr);
			$ret = $numValue * 24 * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "3months" or "5months"
		$findStr = "months";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-6;
			$numValue = int($numStr);
			$ret = $numValue * 30 * 24 * 3600 * 1000 + $numValue * 3600 * 440 * 24;
			return $ret;
		}
		# if ttl is in format "1month"
		$findStr = "month";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-5;
			$numValue = int($numStr);
			$ret = $numValue * 30 * 24 * 3600 * 1000 + $numValue * 3600 * 440 * 24;
			return $ret;
		}
		
		# if ttl is in format "1M"
		$findStr = "M";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			$ret = $numValue * 30 * 24 * 3600 * 1000 + $numValue * 3600 * 440 * 24;
			return $ret;
		}
		
		# if ttl is in format "3minutes" or "5minutes"
		$findStr = "minutes";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-7;
			$numValue = int($numStr);
			$ret = $numValue * 60 * 1000;
			return $ret;
		}
		
		# if ttl is in format "1minute"
		$findStr = "minute";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-6;
			$numValue = int($numStr);
			$ret = $numValue * 60 * 1000;
			return $ret;
		}
		# if ttl is in format "1min"
		$findStr = "min";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-3;
			$numValue = int($numStr);
			$ret = $numValue * 60 * 1000;
			return $ret;
		}
		# if ttl is in format "3hours" or "10hours"
		$findStr = "hours";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-5;
			$numValue = int($numStr);
			$ret = $numValue * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "1hour"
		$findStr = "hour";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-4;
			$numValue = int($numStr);
			$ret = $numValue * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "1hr"
		$findStr = "hr";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-2;
			$numValue = int($numStr);
			$ret = $numValue * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "2weeks" or "7weeks"
		$findStr = "weeks";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-5;
			$numValue = int($numStr);
			$ret = $numValue * 7 * 24 * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "1week"
		$findStr = "week";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-4;
			$numValue = int($numStr);
			$ret = $numValue * 7 * 24 * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "1w"
		$findStr = "w";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			$ret = $numValue * 7 * 24 * 3600 * 1000;
			return $ret;
		}
		# if ttl is in format "2years" or "5years"
		$findStr = "years";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-5;
			$numValue = int($numStr);
			$ret = $numValue * 365 * 24 * 3600 * 1000 + $numValue * 3600 * 250 * 24;
			return $ret;
		}
		# if ttl is in format "1year"
		$findStr = "year";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-4;
			$numValue = int($numStr);
			$ret = $numValue * 365 * 24 * 3600 * 1000 + $numValue * 3600 * 250 * 24;
			return $ret;
		}
		# if ttl is in format "1y"
		$findStr = "y";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			$ret = $numValue * 365 * 24 * 3600 * 1000 + $numValue * 3600 * 250 * 24;
			return $ret;
		}
		# if ttl is in format "1msec"
		$findStr = "msec";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-4;
			$numValue = int($numStr);
			return $numValue;
		}
		# if ttl is in format "3seconds" or "25seconds"
		$findStr = "seconds";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-7;
			$numValue = int($numStr);
			return $numValue;
		}
		# if ttl is in format "1second"
		$findStr = "second";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-6;
			$numValue = int($numStr);
			return $numValue;
		}
		# if ttl is in format "1sec"
		$findStr = "sec";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-3;
			$numValue = int($numStr);
			return $numValue;
		}
		# if ttl is in format "1s"
		$findStr = "s";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			return $numValue;
		}
		# if ttl is in format "1m"
		$findStr = "m";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			return $numValue * 60 * 1000;
		}
		# if ttl is in format "1m"
		$findStr = "h";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			return $numValue * 3600 * 1000;
		}
		# if ttl is in format "1d"
		$findStr = "d";
		@matches2 = $ttl =~ /($findStr)/g;
		$count = @matches2;
		if($count > 0) {
			$numStr = substr $ttl,0, $ttlStrLength-1;
			$numValue = int($numStr);
			return $numValue * 24 * 3600 * 1000;
		}
	return $ret;
}
1;