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
use Common::ConstValues;
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
		_innerCLType1 => shift, 
		_innerCLType2 => shift, 
		_innerCLType3 => shift, 
	};
	bless $self,$class;
	return $self;
}

#get-set method for itsTypeStr
sub setItsTypeStr {
	my ($self,$clTypeStr) = @_;
	$self->{_itsTypeStr} = "".$clTypeStr if defined ($clTypeStr);
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
sub isCLTypePrimitive2 {
	my @list = @_;
	my $input = $list[1];
	return isInputPrimitive($input);
}

# This function does the work of checking if the  input passing to the function is for primitive CLType,  
# type that has no recursive CLType inside (such as bool,  i32,  i64,  u8,  u32,  u64,  u128,  u266,  u512,  string,  unit,  publickey,  key,  ...)
sub isInputPrimitive {
	my @list = @_;
	my $input = $list[0];
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
	my $ret = isInputPrimitive($self->{_itsTypeStr});
	return $ret;
}

# This function get the CLType base on the Json input that represent the CLType
# This function simply check if the input is of type primitive, if yes then getting cltype for primitive is called, otherwise
# getting cltype for compound is called
sub getCLType{
	my @list = @_;
	my $input = $list[1];
	if (isInputPrimitive($input)) {
		return getCLTypePrimitive($input);
	} else {
		return getCLTypeCompound($input);
	}
}

# This function does the work of getting the primitive  CLType from the given Json input  
# Primitive CLType is type that has no recursive CLType inside (such as bool,  i32,  i64,  u8,  u32,  u64,  u128,  u266,  u512,  string,  unit,  publickey,  key,  ...)
sub getCLTypePrimitive {
	my @list = @_;
	my $input = $list[0];
	my $ret = new CLValue::CLType();
	$ret->setItsTypeStr($input);
	return $ret;
	
}

# This function does the work of getting the compound  CLType from the given Json input  
# Primitive CLType is type that does have recursive CLType inside (such as list,  map,  result,  tuple1,  tuple2,  tuple3,  option)
sub getCLTypeCompound {
	my @list = @_;
	my $input = $list[0];
	my $ret = new CLValue::CLType();
	
	# Get CLType of Type Option
	my $typeOption = $input->{'Option'};
	if($typeOption) {
		$ret->setItsTypeStr("Option");
		my $innerType = CLValue::CLType->getCLType($typeOption);
		$ret->setInnerCLType1($innerType);
	}
	
	# Get CLType of Type List
	my $typeList = $input->{'List'};
	if ($typeList) {
		$ret->setItsTypeStr("List");
		my $innerType = CLValue::CLType->getCLType($typeList);
		$ret->setInnerCLType1($innerType);
	}
	
	# Get CLType of Type Map
	my $typeMap = $input->{'Map'};
	if ($typeMap) {
		$ret->setItsTypeStr("Map");
		my $innerType1 = CLValue::CLType->getCLType($typeMap->{'key'});
		my $innerType2 = CLValue::CLType->getCLType($typeMap->{'value'});
		$ret->setInnerCLType1($innerType1);
		$ret->setInnerCLType2($innerType2);
	}
	
	#Get CLType of Type Result
	my $typeResult = $input->{'Result'};
	if ($typeResult) {
		$ret->setItsTypeStr("Result");
		my $innerType1 = CLValue::CLType->getCLType($typeResult->{'ok'});
		my $innerType2 = CLValue::CLType->getCLType($typeResult->{'err'});
		$ret->setInnerCLType1($innerType1);
		$ret->setInnerCLType2($innerType2);
	}
	
	#Get CLType of Type ByteArray
	my $typeBA = $input->{'ByteArray'};
	if ($typeBA) {
		$ret->setItsTypeStr("ByteArray");
	}
	
	#Get CLType of Type Tuple1
	my $typeTuple1 = $input->{'Tuple1'};
	if ($typeTuple1) {
		$ret->setItsTypeStr("Tuple1");
		my @listTuple1 = @{$typeTuple1};
		my $counter = 0;
		foreach(@listTuple1) {
			if($counter == 0) {
				my $cl1 = $_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
			}
			$counter ++;
		}
	}
	
	#Get CLType of Type Tuple2
	my $typeTuple2 = $input->{'Tuple2'};
	if ($typeTuple2) {
		$ret->setItsTypeStr("Tuple2");
		my @listTuple2 = @{$typeTuple2};
		my $counter = 0;
		foreach(@listTuple2) {
			if($counter == 0) {
				my $cl1 = $_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
			} elsif($counter == 1) {
				my $cl2 = $_;
				my $innerType2 = CLValue::CLType->getCLType($cl2);	
				$ret->setInnerCLType2($innerType2);
			}
			$counter ++;
		}
	}

	#Get CLType of Type Tuple3
	my $typeTuple3 = $input->{'Tuple3'};
	if ($typeTuple3) {
		$ret->setItsTypeStr("Tuple3");
		my @listTuple3 = @{$typeTuple3};
		my $counter = 0;
		foreach(@listTuple3) {
			if($counter == 0) {
				my $cl1 = $_;
				my $innerType1 = CLValue::CLType->getCLType($cl1);
				$ret->setInnerCLType1($innerType1);
			} elsif($counter == 1) {
				my $cl2 = $_;
				my $innerType2 = CLValue::CLType->getCLType($cl2);	
				$ret->setInnerCLType2($innerType2);
			} elsif($counter == 2) {
				my $cl3 = $_;
				my $innerType3 = CLValue::CLType->getCLType($cl3);	
				$ret->setInnerCLType3($innerType3);
			}
			$counter ++;
		}
	}
	return $ret;
}
# This function turn a CLType object to a Json string
sub toJsonString {
	my ($self) = @_;
	my $ret = isInputPrimitive($self->{_itsTypeStr});
	if($ret == 1) {
		my $ret = $self->clTypePrimitiveToJsonString($self->{_itsTypeStr});
		return "\"".$ret."\"";
	} else {
		return $self->clTypeCompoundToJsonString();
	}
}

# This function generate the Json String represent the CLType primitive, such as Bool, I32, I64 , U32 , ...
# CLType that does not contain recursive declaration inside its body*/
sub clTypePrimitiveToJsonString {
	#my @vars = @_;
	#my $type =  $vars[0];
	my ($self) = @_;
	my $type = $self->{_itsTypeStr};
	if($type eq $Common::ConstValues::CLTYPE_BOOL) {
		return "Bool";
	} elsif ($type eq $Common::ConstValues::CLTYPE_I32) {
		return "I32";
	} elsif ($type eq $Common::ConstValues::CLTYPE_I64) {
		return "I64";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U8) {
		return "U8";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U32) {
		return "U32";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U64) {
		return "U64";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U128) {
		return "U128";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U256) {
		return "U256";
	} elsif ($type eq $Common::ConstValues::CLTYPE_U512) {
		return "U512";
	} elsif ($type eq $Common::ConstValues::CLTYPE_UNIT) {
		return "Unit";
	} elsif ($type eq $Common::ConstValues::CLTYPE_STRING) {
		return "String";
	} elsif ($type eq $Common::ConstValues::CLTYPE_KEY) {
		return "Key";
	} elsif ($type eq $Common::ConstValues::CLTYPE_UREF) {
		return "URef";
	} elsif ($type eq $Common::ConstValues::CLTYPE_PUBLIC_KEY) {
		return "PublicKey";
	} elsif ($type eq $Common::ConstValues::CLTYPE_ANY) {
		return "Any";
	}
	return $Common::ConstValues::INVALID_VALUE;
}
# This function generate the Json String represent the CLType compound, such as List, Map, Option, Result, Tuple1, Tuple2, Tuple3 ...
# CLType that contains recursive declaration inside its body
sub clTypeCompoundToJsonString {
	my ($self) = @_;
	my $type =  $self->{_itsTypeStr};
	if($type eq $Common::ConstValues::CLTYPE_BYTEARRAY) {
		return "{\"ByteArray\": 32}";
	} elsif ($type eq $Common::ConstValues::CLTYPE_TUPLE1) {
		my $inner1 = new CLValue::CLType();
		$inner1 = $self->{_innerCLType1};
		if($inner1->isCLTypePrimitive()) {
			my $clTypeStr = $inner1->clTypePrimitiveToJsonString();
			return "{\"Tuple1\": \"".$clTypeStr."\"}";
		} else {
			my $clTypeStr = $inner1->clTypeCompoundToJsonString();
			return "{\"Tuple1\": ".$clTypeStr."}"
		}
	} elsif ($type eq $Common::ConstValues::CLTYPE_TUPLE2) {
		 my $ret = "{\"Tuple2\": [";
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 if($inner1->isCLTypePrimitive()) {
			my $clTypeStr = "\"".$inner1->clTypePrimitiveToJsonString()."\"";
			$ret = $ret.$clTypeStr.",";
		} else {
			my $clTypeStr = $inner1->clTypeCompoundToJsonString();
			$ret = $ret.$clType1Str.",";
		}
		 my $inner2 = new CLValue::CLType();
		 $inner2 = $self->{_innerCLType2};
		 if($inner2->isCLTypePrimitive()) {
			my $clTypeStr2 = "\"".$inner2->clTypePrimitiveToJsonString()."\"";
			$ret = $ret.$clTypeStr2."]";
		} else {
			my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
			$ret = $ret.$clType1Str2."]";
		}
	} elsif ($type eq $Common::ConstValues::CLTYPE_TUPLE3) {
		 my $ret = "{\"Tuple3\": [";
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 if($inner1->isCLTypePrimitive()) {
			my $clTypeStr = "\"".$inner1->clTypePrimitiveToJsonString()."\"";
			$ret = $ret.$clTypeStr.",";
		} else {
			my $clTypeStr = $inner1->clTypeCompoundToJsonString();
			$ret = $ret.$clType1Str.",";
		}
		 my $inner2 = new CLValue::CLType();
		 $inner2 = $self->{_innerCLType2};
		 if($inner2->isCLTypePrimitive()) {
			my $clTypeStr2 = "\"".$inner2->clTypePrimitiveToJsonString()."\"";
			$ret = $ret.$clTypeStr2.",";
		} else {
			my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
			$ret = $ret.$clType1Str2.",";
		}
		
		my $inner3 = new CLValue::CLType();
		$inner3 = $self->{_innerCLType2};
		if($inner3->isCLTypePrimitive()) {
			my $clTypeStr3 = "\"".$inner3->clTypePrimitiveToJsonString()."\"";
			$ret = $ret.$clTypeStr3."]";
		} else {
			my $clTypeStr3 = $inner3->clTypeCompoundToJsonString();
			$ret = $ret.$clType1Str3."]";
		}
	}
	elsif ($type eq $Common::ConstValues::CLTYPE_MAP) {
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 my $inner2 = new CLValue::CLType();
		 $inner2 = $self->{_innerCLType2};
		 if($inner1->isCLTypePrimitive()) {
			my $clTypeStr1 = $inner1->clTypePrimitiveToJsonString();
			if($inner2->isCLTypePrimitive()) {
				my $clTypeStr2 = $inner2->clTypePrimitiveToJsonString();
				return "{\"Map\": {\"key\":\"".$clTypeStr1."\", \"value\":\"".$clTypeStr2."\")}}";
			} else {
				my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
				return "{\"Map\": {\"key\":".$clTypeStr1.", \"value\":".$clTypeStr2.")}}";
			}
			
		} else {
			my $clTypeStr1 = $inner1->clTypeCompoundToJsonString();
			if($inner2->isCLTypePrimitive()) {
				my $clTypeStr2 = $inner2->clTypePrimitiveToJsonString();
				return "{\"Map\": {\"key\":".$clTypeStr1.", \"value\":\"".$clTypeStr2."\")}}";
			} else {
				my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
				return "{\"Map\": {\"key\":".$clTypeStr1.", \"value\":".$clTypeStr2.")}}";
			}
		}
	}
	elsif ($type eq $Common::ConstValues::CLTYPE_LIST) {
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 if($inner1->isCLTypePrimitive()) {
		 	my $clTypeStr1 = $inner1->clTypePrimitiveToJsonString();
		 	return "{\"List\": \"".$clTypeStr1."\"}"
		 } else {
		 	my $clTypeStr1 = $inner1->clTypeCompoundToJsonString();
		 	return "{\"List\": ".$clTypeStr1."}"
		 }
	} elsif ($type eq $Common::ConstValues::CLTYPE_OPTION) {
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 if($inner1->isCLTypePrimitive()) {
		 	my $clTypeStr1 = $inner1->clTypePrimitiveToJsonString();
		 	return "{\"Option\": \"".$clTypeStr1."\"}"
		 } else {
		 	my $clTypeStr1 = $inner1->clTypeCompoundToJsonString();
		 	return "{\"Option\": ".$clTypeStr1."}"
		 }
	} elsif ($type eq $Common::ConstValues::CLTYPE_RESULT) {
		 my $inner1 = new CLValue::CLType();
		 $inner1 = $self->{_innerCLType1};
		 my $inner2 = new CLValue::CLType();
		 $inner2 = $self->{_innerCLType2};
		 if($inner1->isCLTypePrimitive()) {
			my $clTypeStr1 = $inner1->clTypePrimitiveToJsonString();
			if($inner2->isCLTypePrimitive()) {
				my $clTypeStr2 = $inner2->clTypePrimitiveToJsonString();
				return "{\"Result\": {\"ok\":\"".$clTypeStr1."\", \"err\":\"".$clTypeStr2."\")}}";
			} else {
				my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
				return "{\"Result\": {\"ok\":".$clTypeStr1.", \"err\":".$clTypeStr2.")}}";
			}
			
		} else {
			my $clTypeStr1 = $inner1->clTypeCompoundToJsonString();
			if($inner2->isCLTypePrimitive()) {
				my $clTypeStr2 = $inner2->clTypePrimitiveToJsonString();
				return "{\"Result\": {\"ok\":".$clTypeStr1.", \"err\":\"".$clTypeStr2."\")}}";
			} else {
				my $clTypeStr2 = $inner2->clTypeCompoundToJsonString();
				return "{\"Result\": {\"ok\":".$clTypeStr1.", \"err\":".$clTypeStr2.")}}";
			}
		}
	} else {
        return $Common::ConstValues::INVALID_VALUE;
    }
	
}
1;