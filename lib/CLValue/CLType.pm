=comment
Class built for storing the cl_type value of a CLValue object.
For example take this CLValue object
{
"bytes": "0400e1f505"
"parsed": "100000000"
"cl_type": "U512"
}
Then the CLType will hold the value of U512.
There are some more attributes in the object to store more information in its value, 
used to build   recursived CLType,  such as List,  Map,  Tuple,  Result,  Option
 */
=cut
package CLValue::CLType;

use feature qw(switch);
use JSON;
sub new {
	my $class = shift;
	my $self = {
		# Type of the CLType in String,  can be Bool,  String,  I32,  I64,  List,  Map, ...
		_itsTypeStr => shift, 
		# innerCLType to hold value for the following type: 
    	# Option,  Result,  Tuple1 will take only 1 item:  innerCLType1
    	# Map,  Tuple2 will take 2  item:  innerCLType1, innerCLType2
    	# Tuple3 will take 3 item:  innerCLType1,  innerCLType2,  innerCLType3
		_innerCLTYpe1 => shift, 
		_innerCLTYpe2 => shift, 
		_innerCLTYpe3 => shift, 
	};
	bless $self,$class;
	return $self;
}

#get-set method for itsTypeStr

sub setItsTypeStr {
	my ($self,$clTypeStr) = @_;
	$self->{_itsTypeStr} = $clTypeStr if defined ($clTypeStr);
	return $self->{_itsTypeStr};
}
sub getItsTypeStr {
	my ($self) = @_;
	return $self->{_itsTypeStr};
}

#get-set method for innerCLType1

sub setInnerCLType1 {
	my ($self,$clType1) = @_;
	$self->{_innerCLType1} = $clType1 if defined($clType1);
	return $self->{_innerCLType1};
}

sub getInnerCLType1 {
	my ($self) = @_;
	return $self->{_innerCLType1};
}

#get-set method for innertType2

sub setInnerCLType2 {
	my ($self,$clType2) = @_;
	$self->{_innerCLType2} = $clType2 if defined ($clType2);
	return $self->{_innerCLType2};
}
sub getInnerCLType2 {
	my ($self) = @_;
	return $self->{_innerCLType2};
}

#get-set method for innerCLType3

sub setInnerCLType3 {
	my ($self,$clType3) = @_;
	$self->{_innerCLType3} = $clType3 if defined ($clType3);
	return $self->{_innerCLTYpe3};
}
sub getInnerCLType3 {
	my ($self) = @_;
	return $self->{_innerCLType3};
}
# This function does the work of checking if the  input passing to the function is for primitive CLType,  
# type that has no recursive CLType inside (such as bool,  i32,  i64,  u8,  u32,  u64,  u128,  u266,  u512,  string,  unit,  publickey,  key,  ...)
sub test{
	print "\nTESTTEST test called\n";
}

sub isInputPrimitive {
	my @list = @_;
	my $input = $list[0];
	print "------input for checking primitive:".$input."\n";
	if($input eq "Bool") {
		return 1;
	} elsif ($input eq "I32") {
		return 1;
	} elsif ($input eq "I64") {
		return 1;
	} elsif ($input eq "U8") {
		return 1;
	} elsif ($input eq "U32") {
		return 1;
	} elsif ($input eq "U64") {
		return 1;
	} elsif ($input eq "U128") {
		return 1;
	} elsif ($input eq "U256") {
		return 1;
	} elsif ($input eq "U512") {
		return 1;
	} elsif ($input eq "String") {
		return 1;
	} elsif ($input eq "Unit") {
		return 1;
	} elsif ($input eq "PublicKey") {
		return 1;
	} elsif ($input eq "Key") {
		return 1;
	} elsif ($input eq "URef") {
		return 1;
	} elsif ($input eq "ByteArray") {
		return 1;
	} elsif ($input eq "Any") {
		return 1;
	} else  {
		return 0;
	}
}
# This function does the work of checking if the  CLType itself is primitive,  
# type that has no recursive CLType inside (such as bool,  i32,  i64,  u8,  u32,  u64,  u128,  u266,  u512,  string,  unit,  publickey,  key,  ...)

sub isCLTypePrimitive {
	my ($self) = @_;
	print "CLTYpe to check with its type:".$self->{_itsTypeStr}."\n";
	my $ret = $self->isInputPrimitive($self->{_itsTypeStr});
	return $ret;
}
sub getCLType{
	my @list = @_;
	my $input = $list[1];
	print "-----get cltype from this str:".$input."\n";
	if (isInputPrimitive($input)) {
		print "\nCltype of primitive\n";
		return getCLTypePrimitive($input);
	} else {
		print "\nCltype of compound\n";
		return getCLTypeCompound($input);
	}
}
sub getCLTypePrimitive {
	my @list = @_;
	my $input = $list[0];
	print "Get clType primitive from this Str:".$input."\n";
	my $ret = new CLValue::CLType();
	$ret->setItsTypeStr($input);
	return $ret;
	
}
sub getCLTypeCompound {
	my @list = @_;
	my $input = $list[0];
	print "Get clType compound from this Str:".$input."\n";
	my $ret = new CLValue::CLType();
	
	# Get CLType of Type Option
	my $typeOption = $input->{'Option'};
	if($typeOption) {
		print "Of type option";
		$ret->setItsTypeStr("Option");
		print "ABOUT TO GET INNER CLTYPE FOR OPTION WITH jsonOption type:".$typeOption."\n";
		my $innerType = CLValue::CLType->getCLType($typeOption);
		print "Inner type for Option is:".$innerType->getItsTypeStr()."\n";
		$ret->setInnerCLType1($innerType);
	}
	
	# Get CLType of Type List
	my $typeList = $input->{'List'};
	if ($typeList) {
		print "Of type List";
		$ret->setItsTypeStr("List");
		print "ABOUT TO GET INNER CLTYPE FOR LIST WITH jsonList type:".$typeList."\n";
		my $innerType = CLValue::CLType->getCLType($typeList);
		print "Inner type for List is:".$innerType->getItsTypeStr()."\n";
		$ret->setInnerCLType1($innerType);
	}
	
	# Get CLType of Type Map
	my $typeMap = $input->{'Map'};
	if ($typeMap) {
		print "Of type Map";
		$ret->setItsTypeStr("Map");
		print "ABOUT TO GET INNER CLTYPE FOR MAP WITH jsonMap type:".$typeMap."\n";
		my $innerType1 = CLValue::CLType->getCLType($typeMap->{'key'});
		print "Inner type key for Map is:".$innerType1->getItsTypeStr()."\n";
		my $innerType2 = CLValue::CLType->getCLType($typeMap->{'value'});
		print "Inner type value for Map is:".$innerType2->getItsTypeStr()."\n";
		$ret->setInnerCLType1($innerType1);
		$ret->setInnerCLType2($innerType2);
	}
	
	#Get CLType of Type Result
	my $typeResult = $input->{'Result'};
	if ($typeResult) {
		print "Of type Result";
		$ret->setItsTypeStr("Result");
		print "ABOUT TO GET INNER CLTYPE FOR RESULT WITH jsonResult type:".$typeResult."\n";
		my $innerType1 = CLValue::CLType->getCLType($typeResult->{'ok'});
		print "Inner type ok for Result is:".$innerType1->getItsTypeStr()."\n";
		my $innerType2 = CLValue::CLType->getCLType($typeResult->{'err'});
		print "Inner type err for Map is:".$innerType2->getItsTypeStr()."\n";
		$ret->setInnerCLType1($innerType1);
		$ret->setInnerCLType2($innerType2);
	}
	
	#Get CLType of Type ByteArray
	my $typeBA = $input->{'ByteArray'};
	if ($typeBA) {
		print "Of type ByteArray";
		$ret->setItsTypeStr("ByteArray");
	}
	
	#Get CLType of Type Tuple1
	my $typeTuple1 = $input->{'Tuple1'};
	if ($typeTuple1) {
		print "Of type Tuple1";
		$ret->setItsTypeStr("Tuple1");
		my @listTuple1 = @{$typeTuple1};
		my $counter = 0;
		foreach(@listTuple1) {
			if($counter == 0) {
				my $cl1 = @_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
				print "Inner type for Tuple1 item 1 is:".$innerType1->getItsTypeStr()."\n";
			}
			$counter ++;
		}
	}
	
	#Get CLType of Type Tuple2
	my $typeTuple2 = $input->{'Tuple2'};
	if ($typeTuple2) {
		print "Of type Tuple2";
		$ret->setItsTypeStr("Tuple2");
		my @listTuple2 = @{$typeTuple2};
		my $counter = 0;
		foreach(@listTuple2) {
			if($counter == 0) {
				my $cl1 = @_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
				print "Inner type for Tuple2 item 1 is:".$innerType1->getItsTypeStr()."\n";
			} elsif($counter == 1) {
				my $cl2 = @_;
				my $innerType2 = CLValue::CLType->getCLType($cl2);	
				$ret->setInnerCLType2($innerType2);			
				print "Inner type for Tuple2 item 2 is:".$innerType2->getItsTypeStr()."\n";
			}
			$counter ++;
		}
	}

	#Get CLType of Type Tuple3
	my $typeTuple3 = $input->{'Tuple3'};
	if ($typeTuple3) {
		print "Of type Tuple3";
		$ret->setItsTypeStr("Tuple3");
		my @listTuple3 = @{$typeTuple3};
		my $counter = 0;
		foreach(@listTuple3) {
			if($counter == 0) {
				my $cl1 = @_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
				print "Inner type for Tuple2 item 1 is:".$innerType1->getItsTypeStr()."\n";
			} elsif($counter == 1) {
				my $cl2 = @_;
				my $innerType2 = CLValue::CLType->getCLType($cl2);	
				$ret->setInnerCLType2($innerType2);			
				print "Inner type for Tuple2 item 2 is:".$innerType2->getItsTypeStr()."\n";
			} elsif($counter == 2) {
				my $cl3 = @_;
				my $innerType3 = CLValue::CLType->getCLType($cl3);	
				$ret->setInnerCLType3($innerType3);			
				print "Inner type for Tuple2 item 3 is:".$innerType3->getItsTypeStr()."\n";
			}
			$counter ++;
		}
	}
	return $ret;
}
1;