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
	$self->{_innerParse1} = $innerParse1 if defined($innerParse1);
	return $self->{_innerParse1};
}
sub getInnerParse1 {
	my ($self) = @_;
	return $self->{_innnerParse1};
}

#get-set method for _innerParsed2
sub setInnerParse2 {
	my ($self,$innerParse2) = @_;
	$self->{_innerParse2} = $innerParse2 if defined($innerParse2);
	return $self->{_innerParse2};
}
sub getInnerParse2 {
	my ($self) = @_;
	return $self->{_innnerParse2};
}

#get-set method for _innerParsed3
sub setInnerParse3 {
	my ($self,$innerParse3) = @_;
	$self->{_innerParse3} = $innerParse3 if defined($innerParse3);
	return $self->{_innerParse3};
}
sub getInnerParse3 {
	my ($self) = @_;
	return $self->{_innnerParse3};
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
	#$ret->setItsCLType($clType);
	#$ret->setItsValueStr("Compound");
	# with Option value, the cltype will get the inner cltype1
	if($clType->getItsTypeStr() eq "Option") {
		print "\nAbout to get parse value for Option cltype\n";
		my $innerCLType = $clType->getInnerCLType1();
		print "\nInner cltype is:".$innerCLType->getItsTypeStr()."\n";
		$ret = getCLParsed2($json,$innerCLType);
	} elsif($clType->getItsTypeStr() eq "List") {
		print "\nAbout to get parse value for List cltype\n";
		my $innerCLType = $clType->getInnerCLType1();
		print "\nInner cltype of List is:".$innerCLType->getItsTypeStr()." and Json is:".$json."\n";
		foreach($json) {
			my @oneElement = @{$_};
			print "Element is: ".$_."\n";
			foreach(@oneElement) {
				my $oE = $_;
				print "Inner element is:".$oE."\n";
			}
		}
		#$ret = getCLParsed2($json,$innerCLType);
	} elsif($clType->getItsTypeStr() eq "Result") {
		
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
	print "In get CLParse, json: ".$json;
	print "And clType:".$clType->getItsTypeStr()."\n";
	my $ret = new CLValue::CLParse();
	if ($clType->isCLTypePrimitive()) {
		print "Get parse for cltype primitive, with CLTYPE:".$clType->getItsTypeStr()."\n";
		$ret = getCLParsedPrimitive($json,$clType);
	} else {
		print "Get parse for cltype compound";
		$ret = getCLParsedCompound($json,$clType);
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