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
use CLValue::CLType;
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
		my $innerCLType = $clType->getInnerCLType1();
		$ret = getCLParsed2($json,$innerCLType);
	} elsif($clType->getItsTypeStr() eq "List") {  # with List value, the cltype will get the inner cltype1
		my $innerCLType = $clType->getInnerCLType1();
		my @listValue=();
		my $counterList = 0;
		foreach($json) {
			my @oneElement = @{$_};
			$counterList ++;
			foreach(@oneElement) {
				my $oE = $_;
				my $oneParse = getCLParsed2($oE,$innerCLType);
				push(@listValue,$oneParse);
			}
		}
		$ret->setItsValueList(@listValue);
		$ret->setItsValueStr("List assigned");
		my $listLen = @listValue;
	} elsif($clType->getItsTypeStr() eq "Result") { # with Result value, the cltype will get the inner cltype1 for Ok, inner cltype2 for Err
		my $valueOK = $json->{'Ok'};
		my $valueErr = $json->{'Err'};
		if($valueOK) {
			my $innerCLType = $clType->getInnerCLType1();
			$ret->setItsValueStr("Ok");
			my $value = getCLParsed2($valueOK,$innerCLType);
			$ret->setInnerParse1($value);
		} elsif($valueErr) {
			$ret->setItsValueStr("Err");
			my $innerCLType = $clType->getInnerCLType2();
			my $value = getCLParsed2($valueErr,$innerCLType);
			$ret->setInnerParse1($value);
		}
	} elsif($clType->getItsTypeStr() eq "Map") { # with Map value, the cltype will get the inner cltype1 for key, inner cltype2 for value
		my $counter = 0;
		foreach($json) {
			my @oneElement = @{$_};
			my $listKeyParse = new CLValue::CLParse();
			my $listValueParse = new CLValue::CLParse();
			my @listKey = ();
			my @listValue = ();
			foreach(@oneElement) {
				my $oE = $_;
				$counter ++;
				my $clTypeKey = $clType->getInnerCLType1();
				my $clTypeValue = $clType->getInnerCLType2();
				my $keyParse = getCLParsed2($oE->{'key'},$clTypeKey);
				my $valueParse = getCLParsed2($oE->{'value'},$clTypeValue);
				push(@listKey,$keyParse);
				push(@listValue,$valueParse);
			}
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
			my  @list = @{$_};
			foreach(@list) {
				if($counter == 0) { # get parse for first tuple
					my $oE = $_;
					$tupleParse1 = getCLParsed2($oE,$clType1);
				} elsif($counter == 1) { # get parse for second tuple
					my $oE = $_;
					$tupleParse2 = getCLParsed2($oE,$clType2);
				}
				$counter ++;
			}
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
			my  @list = @{$_};
			foreach(@list) {
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
		}
		$ret->setItsValueStr("Tuple 3 value assigned");
		$ret->setInnerParse1($tupleParse1);
		$ret->setInnerParse2($tupleParse2);
		$ret->setInnerParse3($tupleParse3);
	}
	return $ret;
}

# Generate the CLParse object from JsonObject or String with given information of Type, used for inner class call
sub getCLParsed2 {
	my @list = @_;
	my $json = $list[0];
	my $clType = $list[1];
	my $ret = new CLValue::CLParse();
	if($json) { # if the parse value not NULL
		if ($clType->isCLTypePrimitive()) {
			$ret = getCLParsedPrimitive($json,$clType);
		} else {
			$ret = getCLParsedCompound($json,$clType);
		}
	} else { # if the parse value is NULL
		#$ret->setItsValueStr("NULL_VALUE");
		$ret->setItsValueStr($Common::ConstValues::NULL_VALUE);
	}
	return $ret;
}
# Generate the CLParse object from JsonObject or String with given information of Type, used for outter class call
sub getCLParsed {
	my @list = @_;
	my $json = $list[1];
	my $clType = $list[2];
	my $ret = getCLParsed2($json,$clType);
	return $ret;
}

# This function turn a CLParsed to a Json String that represents that CLParsed. It is used to generate the
# Json string for account_put_deploy RPC call
sub toJsonString {
	my ($self) = @_;
	my $clType = new CLValue::CLType();
	$clType = $self->{_itsCLType};
	if($clType->isCLTypePrimitive()) {
		return $self->parsedPrimitiveToJsonString();
	} else {
		return $self->parsedCompoundToJsonString();
	}
}
# This function turn a CLParsed of type primitive to a Json String that represents that CLParsed. It is used to generate the
# Json string for account_put_deploy RPC call
sub parsedPrimitiveToJsonString {
	my ($self) = @_;
	my $clType = new CLValue::CLType();
	$clType = $self->{_itsCLType};
	my $clTypeStr = $clType->setItsTypeStr();
	my $ret = "";
	if($clTypeStr eq  $Common::ConstValues::CLTYPE_BOOL) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_I32) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_I64) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U8) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U32) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U64) {
		return $Common::ConstValues::PARSED_FIXED_STRING.":".$self->{_itsValueStr};
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U128) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U256) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_U512) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_STRING) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_UNIT) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_UREF) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_PUBLIC_KEY) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_BYTEARRAY) {
		return "\"".$self->{_itsValueStr}."\""
	} elsif ($clTypeStr eq  $Common::ConstValues::CLTYPE_KEY) {
		my $findStr = "-";
		my $itsValueStr = $self->{_itsValueStr};
		my @matches = split($findStr,$itsValueStr);
		my $firstPrefix = $matches[0];
		if($firstPrefix eq "account") {
			return "{\"Account\":\"".$itsValueStr."\"}"
		} elsif ($firstPrefix eq "hash") {
			return "{\"Hash\":\"".$itsValueStr."\"}"
		} elsif ($firstPrefix eq "uref") {
			return "{\"URef\":\"".$itsValueStr."\"}"
		} else {
		    return $Common::ConstValues::INVALID_VALUE;
		}
	} else {
		return $Common::ConstValues::INVALID_VALUE;
	}
}
sub parsedCompoundToJsonString {
	my ($self) = @_;
	my $clType = new CLValue::CLType();
	$clType = $self->{_itsCLType};
	my $clTypeStr = $clType->setItsTypeStr();
	my $ret = "";
	# CLParse Option to Json String
	if($clTypeStr eq  $Common::ConstValues::CLTYPE_OPTION) {
		if($self->{_itsValueStr} eq $Common::ConstValues::NULL_VALUE) {
			return $Common::ConstValues::PURE_NULL;
		} else {
			my $clParseInner1 = new CLValue::CLParse();
			my $clTypeInner1 = new CLValue::CLType();
			$clParseInner1 = $self->{_innerParsed1};
			$clTypeInner1 = $clParseInner1->getItsCLType();
			if($clTypeInner1->isCLTypePrimitive()) {
				return $clParseInner1->parsedPrimitiveToJsonString();
			} else {
				return $clParseInner1->parsedCompoundToJsonString();
			}
		}
	}
	# CLParse List to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_LIST) {
		my $ret = "[";
		my $elementStr = "";
		my $counter = 0;
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		my @listElement = $clParseInner1->getItsValueList();
		my $totalElement = @listElement;
		my @sequence = (0..$totalElement-1);
		for my $i (@sequence) {
			my $oneParse = new CLValue::CLParse();
			my $oneKey = new CLValue::CLType();
			$oneParse = $listElement[$i];
			$oneKey = $oneParse->getItsCLType();
			if($oneKey->isCLTypePrimitive()) {
				$elementStr = $oneParse->parsedPrimitiveToJsonString();
			} else {
				$elementStr = $oneParse->parsedCompoundToJsonString();
			}
			if($counter < $totalElement) {
				$ret = $ret.$elementStr.",";
			} else {
				$ret = $ret.$elementStr."]";
			}
			$counter ++;
		}
		return $ret;
	}
	# CLParse Result to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_RESULT) {
		my $okErrStr = $self->{_itsValueStr}; # this will take the value of "Ok" or "Err"
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		my $resultStr = "";
		if($clTypeInner1->isCLTypePrimitive()) {
			$resultStr = $clParseInner1->parsedPrimitiveToJsonString();
		} else {
			$resultStr = $clParseInner1->parsedCompoundToJsonString();
		}
		return "{".$okErrStr.":".$resultStr."}";
	}
	# CLParse Map to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_MAP) {
		# get the key list of the map
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		# get the value list of the map
		my $clParseInner2 = new CLValue::CLParse();
		my $clTypeInner2 = new CLValue::CLType();
		$clParseInner2 = $self->{_innerParsed2};
		$clTypeInner2 = $clParseInner2->getItsCLType();
		
		my @listKey = $clTypeInner1->getItsValueList();
		my @listValue = $clTypeInner2->getItsValueList();
		
		my $totalKey = @listKey;
		if($totalKey == 0) {
			return "[]";
		}
		my $ret = "[";
		my $keyStr = "";
		my $valueStr = "";
		my $counter = 0;
		my @sequence = (0..$totalKey-1);
		for my $i (@sequence) {
			# get key json
			my $keyParseElement = new CLValue::CLParse();
			my $keyType = new CLValue::CLType();
			$keyParseElement = $listKey[$i];
			$keyType = $keyParseElement->getItsCLType();
			if($keyType->isCLTypePrimitive()) {
				$keyStr = $keyParseElement->parsedPrimitiveToJsonString();
			} else {
				$keyStr = $keyParseElement->parsedCompoundToJsonString();
			}
			# get value json
			my $valueParseElement = new CLValue::CLParse();
			my $valueType = new CLValue::CLType();
			$valueParseElement = $listValue[$i];
			$valueType = $valueParseElement->getItsCLType();
			if($valueType->isCLTypePrimitive()) {
				$valueStr = $valueParseElement->parsedPrimitiveToJsonString();
			} else {
				$valueStr = $valueParseElement->parsedCompoundToJsonString();
			}
			if($counter < $totalKey) {
				 $ret = $ret."{\"key\": ".$keyStr.",\"value\":".$valueStr."},";
			} else {
				 $ret = $ret."{\"key\": ".$keyStr.",\"value\":".$valueStr."}]";
			}
			$counter ++;
		}
		return $ret;
	}
	# CLParse Tuple1 to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_TUPLE1) {
		my $ret = "[";
		my $tupleStr = "";
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		if($clTypeInner1->isCLTypePrimitive()) {
			$tupleStr = $clParseInner1->parsedPrimitiveToJsonString();
		} else {
			$tupleStr = $clParseInner1->parsedCompoundToJsonString();
		}
		$ret = $ret.$tupleStr."]";
		return $ret;
	}
	# CLParse Tuple2 to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_TUPLE1) {
		my $ret = "[";
		# get tuple 1 string
		my $tupleStr1 = "";
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		if($clTypeInner1->isCLTypePrimitive()) {
			$tupleStr1 = $clParseInner1->parsedPrimitiveToJsonString();
		} else {
			$tupleStr1 = $clParseInner1->parsedCompoundToJsonString();
		}
		
		# get tuple 2 string
		my $tupleStr2 = "";
		my $clParseInner2 = new CLValue::CLParse();
		my $clTypeInner2 = new CLValue::CLType();
		$clParseInner2 = $self->{_innerParsed2};
		$clTypeInner2 = $clParseInner2->getItsCLType();
		if($clTypeInner2->isCLTypePrimitive()) {
			$tupleStr2 = $clParseInner2->parsedPrimitiveToJsonString();
		} else {
			$tupleStr2 = $clParseInner2->parsedCompoundToJsonString();
		}
		$ret = "[".$tupleStr1.",". $tupleStr2."]";
		return $ret;
	}
	# CLParse Tuple3 to Json String
	elsif($clTypeStr eq  $Common::ConstValues::CLTYPE_TUPLE3) {
		my $ret = "[";
		# get tuple 1 string
		my $tupleStr1 = "";
		my $clParseInner1 = new CLValue::CLParse();
		my $clTypeInner1 = new CLValue::CLType();
		$clParseInner1 = $self->{_innerParsed1};
		$clTypeInner1 = $clParseInner1->getItsCLType();
		if($clTypeInner1->isCLTypePrimitive()) {
			$tupleStr1 = $clParseInner1->parsedPrimitiveToJsonString();
		} else {
			$tupleStr1 = $clParseInner1->parsedCompoundToJsonString();
		}
		
		#get tuple 2 string
		my $tupleStr2 = "";
		my $clParseInner2 = new CLValue::CLParse();
		my $clTypeInner2 = new CLValue::CLType();
		$clParseInner2 = $self->{_innerParsed2};
		$clTypeInner2 = $clParseInner2->getItsCLType();
		if($clTypeInner2->isCLTypePrimitive()) {
			$tupleStr2 = $clParseInner2->parsedPrimitiveToJsonString();
		} else {
			$tupleStr2 = $clParseInner2->parsedCompoundToJsonString();
		}
		
		#get tuple 3 string
		my $tupleStr3 = "";
		my $clParseInner3 = new CLValue::CLParse();
		my $clTypeInner3 = new CLValue::CLType();
		$clParseInner3 = $self->{_innerParsed3};
		$clTypeInner3 = $clParseInner3->getItsCLType();
		if($clTypeInner3->isCLTypePrimitive()) {
			$tupleStr3 = $clParseInner3->parsedPrimitiveToJsonString();
		} else {
			$tupleStr3 = $clParseInner3->parsedCompoundToJsonString();
		}
		$ret = "[".$tupleStr1.",". $tupleStr2.",".$tupleStr3."]";
		return $ret;
	} else {
	 	return $Common::ConstValues::INVALID_VALUE;
	}
}
1;