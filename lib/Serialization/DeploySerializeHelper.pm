=comment
This class provides the serialization for Deploy object
=cut

use CLValue::CLType;
use CLValue::CLParse;
use Common::ConstValues; 
use GetDeploy::DeployHeader;
use Serialization::CLParseSerialization;
use GetDeploy::Approval;
use GetDeploy::Deploy;
use Serialization::ExecutableDeployItemSerializationHelper;
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
	my $clParse64 = new CLValue::CLParse();
	my $clType64 = new CLValue::CLType();
	$clType64->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$clParse64->setItsCLType($clType64);
	$clParse64->setItsValueStr("$miliseconds");
	my $parseSerialization = new Serialization::CLParseSerialization();
	$timeStampSerialization = $parseSerialization->serializeFromCLParse($clParse64);
	# Serialization for Header.ttl
	my $ttlMiliseconds = fromTTLToMiliseconds($header->getTTL());
	$clParse64->setItsValueStr("$ttlMiliseconds");
	my $ttlSerialization = $parseSerialization->serializeFromCLParse($clParse64);
	# Serialization for Header.gasPrice
	my $gasPrice = $header->getGasPrice();
	$clParse64->setItsValueStr("$gasPrice");
	my $gasPriceSerialization = $parseSerialization->serializeFromCLParse($clParse64);
	# Serialization for Header.dependency
	my @dependencies = $header->getDependencies();
	my $totalDependency = @dependencies;
	my $clParse32 = new CLValue::CLParse();
	my $clType32 = new CLValue::CLType();
	$clType32->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$clParse32->setItsCLType($clType32);
	$clParse32->setItsValueStr("$totalDependency");
	my $dependencySerialization = $parseSerialization->serializeFromCLParse($clParse32);
	if($totalDependency>0) {
		my @sequenceD = (0..$totalDependency-1);
		for my $i (@sequenceD) {
			$dependencySerialization = $dependencySerialization.$dependencies[$i];
		}
	}
	# Serialization for Header.chainName
	my $clParseString = new CLValue::CLParse();
	my $clTypeString = new CLValue::CLType();
	$clTypeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParseString->setItsCLType($clTypeString);
	$clParseString->setItsValueStr($header->getChainName());
	my $chainNameSerialization = $parseSerialization->serializeFromCLParse($clParseString);
	return $header->getAccount().$timeStampSerialization.$ttlSerialization.$gasPriceSerialization.$header->getBodyHash().$dependencySerialization.$chainNameSerialization;
}
=comment
Serialization for the Deploy Approvals
Rule for serialization:
If the approval list is empty, just return "00000000", which is equals to U32.serialize(0)
If the approval list is not empty, then first get the approval list length, then take the prefixStr = U32.serialize(approvalList.length)
Then concatenate all the elements in the approval list with rule for each element:
1 element serialization = singer + signature
Final result = prefix + (list.serialize)
=cut
sub serializeForDeployApproval {
	my @list = @_;
	my @listApprovals = $list[1];
	my $totalA = @listApprovals;
	my $parse32 = new CLValue::CLParse();
	my $type32 = new CLValue::CLType();
	$type32->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$parse32->setItsCLType($type32);
	$parse32->setItsValueStr("$totalA");
	my $parseSerialization = new Serialization::CLParseSerialization();
	my $ret = $parseSerialization->serializeFromCLParse($parse32);
	if($totalA>0) {
		my @sequence = (0..$totalA-1);
		for my $i (@sequence) {
			my $oneA = new GetDeploy::Approval();
			$oneA = $listApprovals[$i];
			$ret = $ret.$oneA->getSigner().$oneA->getSignature();
		}
	}
	return $ret;
}
=comment
 This function do the serialization for the whole deploy object.
Input: a deploy object
Output: the serialization of the deploy, built with the rule: header serialization + deploy.hash + payment serialization + session serialization + approval serialization
=cut
sub serializeForDeploy {
	my $deploy = new GetDeploy::Deploy();
	my @list = @_;
	$deploy = $list[1];
	my $ret = serializeForHeader("0",$deploy->getHeader());
	$ret = $ret.$deploy->getDeployHash();
	my $ediSerializeHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $paymentSerialization = $ediSerializeHelper->serializeForExecutableDeployItem($deploy->getPayment());
	my $sessionSerialization = $ediSerializeHelper->serializeForExecutableDeployItem($deploy->getSession());
	my $approvalSerialization = serializeForDeployApproval("0",$deploy->getApprovals());
	$ret = $ret.$paymentSerialization.$sessionSerialization.$approvalSerialization;
	return $ret;
	
}
# This function changes ttl (Time to live) to milisecond
# The ttl is in format defined in this link
# https:// docs.rs/humantime/latest/humantime/fn.parse_duration.html
# This function only handle with time format in single form such as "1h", "3days" or "15months"
sub fromTTLToMilisecondsSingle {
	my $ret = "";
	my @list = @_;
	$ttl = $list[0];
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
# This function changes ttl (Time to live) to milisecond
# The ttl is in format defined in this link
# https:// docs.rs/humantime/latest/humantime/fn.parse_duration.html
# This function only handle with time format in single or muliple form such as "1h", "3mins", "3days 2hours 5minutes" or "15months 7weeks"
sub fromTTLToMiliseconds {
	my @list = @_;
	$ttl = $list[0];
	my $findStr = " ";
	my @matches = split($findStr,$ttl);
	my $count = @matches;
	my $ret = 0;
	my $numStr = "";
	my $numValue = 0;
	# if ttl is in form of "1h 2m 30s" or "2days 1hour 3minutes 15s"
	if($count > 0) {
		my @sequence =(0..$count-1);
		for my $i (@sequence) {
			my $ret1 =  fromTTLToMilisecondsSingle($matches[$i]);
			$ret = $ret + $ret1;
		}
		return $ret;
	} 
	# if ttl is in form of single date time such as "1h", "30" or "2days"
	else {
		$ret = fromTTLToMilisecondsSingle($ttl);
		return $ret;
	}
}
1;