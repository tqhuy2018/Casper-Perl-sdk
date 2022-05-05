=comment
Class built for storing the parse value of a CLValue object.
For example take this CLValue object
{
"bytes": "0400e1f505"
"parsed": "100000000"
"cl_type": "U512"
}
Then the parse will hold the value of 100000000.
There are some more attributes in the object to store more information on the type of the parse (CLType),  
its value in String for later handle in serialization or show the information, as commented inside the class.
=cut

package CLValue::CLParse;

use Common::ConstValues;
#constructor
sub new {
	my $class = shift;
	my $self = {
		# Value of the Parse in String format, in the above example this value is 100000000
		_itsValueStr => shift,
		# The CLType of the CLParse, in the above example, the CLType is of type U512
		_itsCLType => shift,
		# innerParsed to hold value for the following type: 
    	# Option,  Result,  Tuple1 will take only 1 item of innerParsed
    	# Map,  Tuple2 will take 2  item of innerParsed
    	# Tuple3 will take 3 item of innerParsed
		_innerParsed1 => shift,
		_innerParsed2 => shift,
		_innerParsed3 => shift,
		#This property is for holding array value of List and FixList, it is a list that can hold list of CLParse elements
		_itsValueList => [ @_ ],
	};
	bless $self, $class;
	return $self;
}

#get-set method for _itsValueInStr
sub setItsValueStr {
	my ($self,$itsValueStr) = @_;
	$self->{_itsValueStr} = $itsValueStr if defined($itsValueStr);
	return $self;
}
sub getItsValueStr {
	my ($self) = @_;
	return $self->{_itsValueStr};
}

#get-set method for _itsCLType
sub setItsCLType {
	my ($self,$itsCLType) = @_;
	$self->{_itsCLType} = $itsCLType if defined ($itsCLType);
	return $self->{_itsCLType};
}
sub getItsCLType{
	my ($self) = @_;
	return $self->{_itsCLType};
}

#get-set method for _innerParsed1
sub setInnerParse1 {
	my ($self,$innerParse1) = @_;
	$self->{_innerParsed1} = $innerParse1 if defined($innerParse1);
	return $self->{_innerParsed1};
}
sub getInnerParse1 {
	my ($self) = @_;
	return $self->{_innerParsed1};
}

#get-set method for _innerParsed2
sub setInnerParse2 {
	my ($self,$innerParse2) = @_;
	$self->{_innerParsed2} = $innerParse2 if defined($innerParse2);
	return $self->{_innerParsed2};
}
sub getInnerParse2 {
	my ($self) = @_;
	return $self->{_innerParsed2};
}

#get-set method for _innerParsed3
sub setInnerParse3 {
	my ($self,$innerParse3) = @_;
	$self->{_innerParsed3} = $innerParse3 if defined($innerParse3);
	return $self->{_innerParsed3};
}
sub getInnerParse3 {
	my ($self) = @_;
	return $self->{_innerParsed3};
}

#get-set method for _itsValueList
sub setItsValueList {
	my ($self,@list) = @_;
	$self->{_itsValueList} = \@list;
	return $self->{_itsValueList};
}
sub getItsValueList{
	my ($self) = @_;
	my @list = @ {$self->{_itsValueList}};
	wantarray ? @list:\@list;
}

# Generate the CLParse object  of type primitive (such as bool,  i32,  i64,  u8,  u32,  u64,  u128,  u266,  u512,  string,  unit,  publickey,  key,  ...)
# from the JSON object fromObj with given clType
# This function will take 2 arguments, first is the Json object for the CLParse, second is the CLType of the CLParse
sub getCLParsedPrimitive {
	my @list = @_;
	my $json = $list[0];
	my $clType = $list[1];
	print "get clparse for cltype primitive, with json:".$json."\n";
	print "get clparse for cltype primitive, with clType:".$clType->getItsTypeStr()."\n";
	my $ret = new CLValue::CLParse();
	$ret->setItsCLType($clType);
	# Get primitive for key, which is complicated, for other type of primitive , the rule for getting parse is simple
	if ($clType->getItsTypeStr() eq "Key") {
		my $parseHash = $json->{'Hash'};
		if($parseHash) {
			$ret->setItsValueStr($parseHash);
		}
		my $parseAccount = $json->{'Account'};
		if($parseAccount) {
			$ret->setItsValueStr($parseAccount);
		}
		my $parseURef = $json->{'URef'};
		if($parseURef) {
			$ret->setItsValueStr($parseURef);
		}
	} else {
		$ret->setItsValueStr($json);
	}
	return $ret;
}
# Generate the CLParse object  of type compound (type with recursive CLValue inside its body,  such as List,  Map,  Tuple ,  Result , Option...)  
# from the JSON object fromObj with given clType
# This function will take 2 arguments, first is the Json object for the CLParse, second is the CLType of the CLParse
sub getCLParsedCompound {
	my @list = @_;
	my $json = $list[0];
	my $clType = $list[1];
	my $ret = new CLValue::CLParse();
	if($clType->getItsTypeStr() eq "Option") { # with Option value, the cltype will get the inner cltype1
		print "\nAbout to get parse value for Option cltype\n";
		my $innerCLType = $clType->getInnerCLType1();
		print "\nInner cltype is:".$innerCLType->getItsTypeStr()."\n";
		$ret = getCLParsed2($json,$innerCLType);
	} elsif($clType->getItsTypeStr() eq "List") {  # with List value, the cltype will get the inner cltype1
		print "\nAbout to get parse value for List cltype\n";
		my $innerCLType = $clType->getInnerCLType1();
		print "\nInner cltype of List is:".$innerCLType->getItsTypeStr()." and Json is:".$json."\n";
		my @listValue=();
		my $counterList = 0;
		foreach($json) {
			my @oneElement = @{$_};
			print "Get List element number ".$counterList."Element is: ".$_."\n";
			$counterList ++;
			foreach(@oneElement) {
				my $oE = $_;
				print "LIST LIST LIST Inner element is:".$oE." and cltype:".$innerCLType->getItsTypeStr()."\n";
				my $oneParse = getCLParsed2($oE,$innerCLType);
				push(@listValue,$oneParse);
			}
		}
		$ret->setItsValueList(@listValue);
		$ret->setItsValueStr("List assigned");
		my $listLen = @listValue;
		print "\n****After parsing list, the length of list is:".$listLen."\n";
	} elsif($clType->getItsTypeStr() eq "Result") { # with Result value, the cltype will get the inner cltype1 for Ok, inner cltype2 for Err
		print "\nAbout to get parse value for Result cltype\n";
		my $valueOK = $json->{'Ok'};
		my $valueErr = $json->{'Err'};
		if($valueOK) {
			my $innerCLType = $clType->getInnerCLType1();
			print "\nInner cltype is for RESULT OK is:".$innerCLType->getItsTypeStr()."\n";
			$ret = getCLParsed2($json,$innerCLType);
		} elsif($valueErr) {
			my $innerCLType = $clType->getInnerCLType2();
			print "\nInner cltype is for RESULT ERR is:".$innerCLType->getItsTypeStr()."\n";
			$ret = getCLParsed2($json,$innerCLType);
		}
	} elsif($clType->getItsTypeStr() eq "Map") { # with Map value, the cltype will get the inner cltype1 for key, inner cltype2 for value
		my $counter = 0;
		foreach($json) {
			my @oneElement = @{$_};
			print "MAP---Element is: ".$_."\n";
			my $listKeyParse = new CLValue::CLParse();
			my $listValueParse = new CLValue::CLParse();
			my @listKey = ();
			my @listValue = ();
			foreach(@oneElement) {
				my $oE = $_;
				print "\n--------------***GET MAP ELEMENT number ".$counter."***--------------\n";
				$counter ++;
				print "Inner element is:".$oE." and key is:".$oE->{'key'}." and value:".$oE->{'value'}."\n";
				my $clTypeKey = $clType->getInnerCLType1();
				my $clTypeValue = $clType->getInnerCLType2();
				print " with cltype for key:".$clTypeKey->getItsTypeStr()."\n";
				print "\nGet key begins\n";
				my $keyParse = getCLParsed2($oE->{'key'},$clTypeKey);
				print "\nGet value begins\n";
				my $valueParse = getCLParsed2($oE->{'value'},$clTypeValue);
				push(@listKey,$keyParse);
				push(@listValue,$valueParse);
			}
			my $listKeyLen = @listKey;
			my $listValueLen = @listValue;
			print "\nTotal key get:".$listKeyLen." and total value get:".$listValueLen."\n";
			$listKeyParse->setItsValueList(@listKey);
			$listKeyParse->setItsValueStr("MAP KEY ASSIGNED");
			$listValueParse->setItsValueList(@listValue);
			$listValueParse->setItsValueStr("MAP VALUE ASSIGNED");
			$ret->setInnerParse1($listKeyParse);
			$ret->setInnerParse2($listValueParse);
			$ret->setItsValueStr("Map parse assigned");
		}
	} elsif($clType->getItsTypeStr() eq "Tuple1") { # with Tuple1 value, the cltype will get the inner cltype1
		my $counter = 0;
		my $clType1 = $clType->getInnerCLType1();
		my $tupleParse1;
		foreach($json) {
			if($counter == 0) { # get parse for first tuple
				my $oE = $_;
				$tupleParse1 = getCLParsed2($oE,$clType1);
			} 
			$counter ++;
		}
		$ret->setItsValueStr("Tuple 1 value assigned");
		$ret->setInnerParse1($tupleParse1);
	} elsif($clType->getItsTypeStr() eq "Tuple2") { # with Tuple2 value, the cltype will get the inner cltype1 and inner cltype2
		my $counter = 0;
		my $clType1 = $clType->getInnerCLType1();
		my $clType2 = $clType->getInnerCLType2();
		my $tupleParse1;
		my $tupleParse2;
		foreach($json) {
			if($counter == 0) { # get parse for first tuple
				my $oE = $_;
				$tupleParse1 = getCLParsed2($oE,$clType1);
			} elsif($counter == 1) { # get parse for second tuple
				my $oE = $_;
				$tupleParse2 = getCLParsed2($oE,$clType2);
			}
			$counter ++;
		}
		$ret->setItsValueStr("Tuple 2 value assigned");
		$ret->setInnerParse1($tupleParse1);
		$ret->setInnerParse2($tupleParse2);
	} elsif($clType->getItsTypeStr() eq "Tuple3") { # with Tuple2 value, the cltype will get the inner cltype1 and inner cltype2 and inner cltype3
	my $counter = 0;
		my $clType1 = $clType->getInnerCLType1();
		my $clType2 = $clType->getInnerCLType2();
		my $clType3 = $clType->getInnerCLType3();
		my $tupleParse1;
		my $tupleParse2;
		my $tupleParse3;
		foreach($json) {
			if($counter == 0) { # get parse for first tuple
				my $oE = $_;
				$tupleParse1 = getCLParsed2($oE,$clType1);
			} elsif($counter == 1) { # get parse for second tuple
				my $oE = $_;
				$tupleParse2 = getCLParsed2($oE,$clType2);
			} elsif($counter == 2) { # get parse for second tuple
				my $oE = $_;
				$tupleParse3 = getCLParsed2($oE,$clType3);
			}
			$counter ++;
		}
		$ret->setItsValueStr("Tuple 3 value assigned");
		$ret->setInnerParse1($tupleParse1);
		$ret->setInnerParse2($tupleParse2);
		$ret->setInnerParse3($tupleParse3);
	}
	return $ret;
}

# Generate the CLParse object from JsonObject or String with given information of Type 
# getCLParsed2 for inner class call
# getCLParsed for outter class call
sub getCLParsed2 {
	my @list = @_;
	my $json = $list[0];
	my $clType = $list[1];
	my $ret = new CLValue::CLParse();
	if($json) { # if the parse value not NULL
		print "In get CLParse, json: ".$json;
		print "And clType:".$clType->getItsTypeStr()."\n";
		if ($clType->isCLTypePrimitive()) {
			print "Get parse for cltype primitive, with CLTYPE:".$clType->getItsTypeStr()."\n";
			$ret = getCLParsedPrimitive($json,$clType);
		} else {
			print "Get parse for cltype compound-------\n";
			$ret = getCLParsedCompound($json,$clType);
		}
	} else { # if the parse value is NULL
		#$ret->setItsValueStr("NULL_VALUE");
		print "\nParse is null and get this value:".$Common::ConstValues::NULL_VALUE."\n";
		$ret->setItsValueStr($Common::ConstValues::NULL_VALUE);
	}
	return $ret;
}
sub getCLParsed {
	my @list = @_;
	my $json = $list[1];
	my $clType = $list[2];
	my $ret = getCLParsed2($json,$clType);
	return $ret;
}
1;