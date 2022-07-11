# Perl version of CLType primitives

## CLType primitives

The CLType is an enum variables, defined at this address: (for Rust version)

https://docs.rs/casper-types/1.4.6/casper_types/enum.CLType.html

In Perl, the CLType when put into usage is part of a CLValue object.

To more detail, a CLValue holds the information like this:

 ```Perl
 {
"bytes":"0400e1f505"
"parsed":"100000000"
"cl_type":"U512"
}
```

or


 ```Perl
 {
"bytes":"010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b"
"parsed":[
          [
             {
             "key":"token_uri"
             "value":"https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk"
             }
          ]
]
"cl_type":{
        "List":{
           "Map":{
           "key":"String"
           "value":"String"
           }
      }
}
 ```
The CLValue is built up with 3 elements: cl_type, parsed and bytes.
In the examples above,
* For the first example:
 - The cl_type is: U512
 - The parsed is: "100000000"
 - The bytes is: "0400e1f505"

* For the second example:
 - The cl_type is: List(Map(String,String))
 - The parsed is:

 ```Perl
 "[
          [
             {
             "key":"token_uri"
             "value":"https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk"
             }
          ]
       ]"
  ```

     - The bytes is: "010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b"

### CLType in detail


In Perl SDK the "cl_type" is wrapped in CLType class, which is declared in  "CLType.pm" file under folder "CLValue". The CLType class stores all information need when you want to declare a CLType, and also this class provides functions to turn JSON object to CLType object and supporter function such as function to check if the CLType hold pure value of CLType with recursive CLType inside its body.

The main properties of the CLType object are:

 ```Perl
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
 ```

In which itsTypeStr is the type of the CLType in String,  can be Bool,  String,  I32,  I64,  List,  Map, ...

The CLType is divided into 2 types: Primitive and Compound.

Primitive CLType is the CLType with no recursive CLType declaration inside its body. The following CLType are primitive: Bool, I32, I64, U8, U32, U64, U128, U256, U512, String, Unit, Key, URef, PublicKey, ByteArray, Any

Compound CLType is the CLType with recursive CLType declaration inside its body. The following CLType are compound: List, Map, Option, Result, Tuple1, Tuple2, Tuple 3.

The variables _innerCLType1, _innerCLType2, _innerCLType3 to hold value for the following type:

Option,  Result,  Tuple1 will take only 1 item:  _innerCLType1

Map,  Tuple2 will take 2  items:  _innerCLType1, _innerCLType2

Tuple3 will take 3 items:  _innerCLType1,  _innerCLType2,  _innerCLType3


These innerCLType variables are lateinit var, which means that they can be initialized or not, depends on the CLType. For example if the CLType is primitive (Bool, I32, I64, U8, U32 ...) , then the 3 variables: _innerCLType1, _innerCLType2, _innerCLType3 is not used and not initialized.

If the CLType is List, then the _innerCLType1 is used in initialized, while _innerCLType2 and _innerCLType3 is not.

If the CLType is Map, then the _innerCLType1, _innerCLType2 are in used and initialized, while _innerCLType3 is not.

If the CLType is Tuple3, all the _innerCLType1, _innerCLType2, _innerCLType3 are used.

The types in String format for CLType is defined in "ConstValues.pm" file under folder "Common". These types in String are used for identifying what the CLType is.

#### Examples of declaring the CLType object for some types:

Declaration for a CLType of type Bool:

 ```Perl
my $clType = new CLValue::CLType();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
 ```

Declaration for a CLType of type Option(U512):

 ```Perl
my $clType = new CLValue::CLType();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
my $innerType1  = new CLValue::CLType();
$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
$clType->setInnerCLType1($innerType1);
 ```


Declaration for a CLType of type Map(String,String):

```Perl
my $clType = new CLValue::CLType();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_MAP);
$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
$clType->setInnerCLType1($innerType1);
my $innerType2  = new CLValue::CLType();
$innerType2->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
$clType->setInnerCLType2($innerType2);
```

### CLParsed in detail 

The "parsed" is wrapped in CLParsed class, which is declared in  "CLParsed.pm" file under folder "CLValue". The CLParsed class stores all information need when you want to declare a CLParsed object, and also this class provides functions to turn JSON object to CLParsed object and supporter function such as function to check if the CLParsed hold pure value of CLType object or with hold value of recursive CLType object inside its body.

The main properties of the CLParsed object are:

```Perl
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
```

In which the property "itsCLType" is to hold CLType of the CLParsed object, which can be 1 among 23 possible value from "Bool", "I32","I64", "U8" ... to "Tuple1", "Tuple2", "Tuple3" and "Any".
 
The property "_itsValueInStr" is to hold value of CLParsed that doesn't contain recursive CLParsed inside its body

The property "_itsCLType" is to hold the CLType for the CLParsed

The property "_itsValueList" is to hold value of List and FixedList elements
 
The property "_innerParsed1" is to hold the inner CLParsed object for the following CLType: Tuple1, Option

The properties "_innerParsed1" and "innerParsed2" are to hold the inner CLParsed for the following CLType: Map, Result, Tuple2

The properties "_innerParsed1", "innerParsed2" and "innerParsed3" are to hold the inner CLParsed for the following CLType: Tuple3

#### Here are some examples of declaring the CLParsed object for some types: 

To declare for a CLParsed of type Bool with value "true":

```Perl
my $clType = new CLValue::CLType();
my $clParsed = new CLValue::CLParse();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
$clParsed->setItsCLType($clType);
$clParsed->setItsValueStr("true");
```

To declare for a CLParsed of type U8 with value "12":

```Perl
my $clType = new CLValue::CLType();
my $clParsed = new CLValue::CLParse();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
$clParsed->setItsCLType($clType);
$clParsed->setItsValueStr("0");
```

To declare for a CLParsed of type U512 with value "999888666555444999887988887777666655556666777888999666999":

```Perl
my $clType = new CLValue::CLType();
my $clParsed = new CLValue::CLParse();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
$clParsed->setItsCLType($clType);
$clParsed->setItsValueStr("999888666555444999887988887777666655556666777888999666999");
```

To declare for a CLParsed of type Option(NULL)

```Perl
my $clType = new CLValue::CLType();
my $clParsed = new CLValue::CLParse();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
$clParsed->setItsCLType($clType);
$clParsed->setItsValueStr($Common::ConstValues::NULL_VALUE);
```

To declare for a CLParsed of type Option(U32(10))

```Perl
my $clType = new CLValue::CLType();
my $clParsed = new CLValue::CLParse();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
$clParsed->setItsCLType($clType);
$clParsed->setItsValueStr("not_null"); # actually you can assign this value to ok, or 1 or any value that is different from $Common::ConstValues::NULL_VALUE
my $clParsedInner1 = new CLValue::CLParse();
my $clTypeInner1 = new CLValue::CLType();
$clTypeInner1->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
$clType->setInnerCLType1($clTypeInner1);
$clParsed->setItsCLType($clType);
$clParsedInner1->setItsCLType($clTypeInner1);
$clParsedInner1->setItsValueStr("10");
$clParsed->setInnerParse1($clParsedInner1);
```

To declare for a List of 3 CLParse U32 numbers 

```Perl
# List of 3 CLParse U32 number assertion
my $clParsed = new CLValue::CLParse();
my $clType = new CLValue::CLType();
$clType->setItsTypeStr($Common::ConstValues::CLTYPE_LIST);
$clParsed->setItsCLType($clType);
# First U32 
my $clParseList1 = new CLValue::CLParse();
my $clTypeList1 = new CLValue::CLType();
$clTypeList1->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
$clParseList1->setItsCLType($clTypeList1);
$clParseList1->setItsValueStr("1");
# Second U32
my $clParseList2 = new CLValue::CLParse();
$clParseList2->setItsCLType($clTypeList1);
$clParseList2->setItsValueStr("2");
# Third U32 
my $clParseList3 = new CLValue::CLParse();
$clParseList3->setItsCLType($clTypeList1);
$clParseList3->setItsValueStr("3");
my @listValue = ($clParseList1,$clParseList2,$clParseList3);
$clParsed->setItsValueList(@listValue);
```

To declare a Map(String,String) base on the deploy at this address: https://testnet.cspr.live/deploy/430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e  refer to session section of the deploy, args item number 86, here is the CLValue detail

<img width="1286" alt="Screen Shot 2022-07-11 at 12 00 36" src="https://user-images.githubusercontent.com/94465107/178192087-93de92a8-66f9-44d0-b1e0-660bf735eca0.png">


and here is the declaration in Perl for such CLParsed in the CLValue

```Perl
my $clParsedMap = new CLValue::CLParse();
my $clTypeMap = new CLValue::CLType();
$clTypeMap->setItsTypeStr($Common::ConstValues::CLTYPE_MAP);
$clParsedMap->setItsCLType($clTypeMap);
# Key generation
# Key CLType declaration
my $clTypeMapKey = new CLValue::CLType();
$clTypeMapKey->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
# First key
my $clParseMapKey1 = new CLValue::CLParse();
$clParseMapKey1->setItsCLType($clTypeMapKey);
$clParseMapKey1->setItsValueStr("contract_package_hash");
# Second key
my $clParseMapKey2 = new CLValue::CLParse();
$clParseMapKey2->setItsCLType($clTypeMapKey);
$clParseMapKey2->setItsValueStr("event_type");
# Third key
my $clParseMapKey3 = new CLValue::CLParse();
$clParseMapKey3->setItsCLType($clTypeMapKey);
$clParseMapKey3->setItsValueStr("reserve0");
# Fourth key
my $clParseMapKey4 = new CLValue::CLParse();
$clParseMapKey4->setItsCLType($clTypeMapKey);
$clParseMapKey4->setItsValueStr("reserve1");
# Map Key assignment
my @listKey = ($clParseMapKey1,$clParseMapKey2,$clParseMapKey3,$clParseMapKey4);
my $innerParseKey = new CLValue::CLParse();
$innerParseKey->setItsValueList(@listKey);
$clParsedMap->setInnerParse1($innerParseKey);
# Value generation
# Value CLType declaration
my $clTypeMapValue = new CLValue::CLType();
$clTypeMapValue->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
# First value
my $clParseMapValue1 = new CLValue::CLParse();
$clParseMapValue1->setItsCLType($clTypeMapValue);
$clParseMapValue1->setItsValueStr("d32DE152c0bBFDcAFf5b2a6070Cd729Fc0F3eaCF300a6b5e2abAB035027C49bc");
# Second value
my $clParseMapValue2 = new CLValue::CLParse();
$clParseMapValue2->setItsCLType($clTypeMapValue);
$clParseMapValue2->setItsValueStr("sync");
# Third value
my $clParseMapValue3 = new CLValue::CLParse();
$clParseMapValue3->setItsCLType($clTypeMapValue);
$clParseMapValue3->setItsValueStr("412949147973569321536747");
# Fourth value
my $clParseMapValue4 = new CLValue::CLParse();
$clParseMapValue4->setItsCLType($clTypeMapValue);
$clParseMapValue4->setItsValueStr("991717147268569848142418");
# Map Key assignment
@listValue = ();
@listValue = ($clParseMapValue1,$clParseMapValue2,$clParseMapValue3,$clParseMapValue4);
my $innerParseValue = new CLValue::CLParse();
$innerParseValue->setItsValueList(@listValue);
$clParsedMap->setInnerParse2($innerParseValue);	
```
### CLValue in detail
 
To store information of one CLValue object, which include the following information: {bytes,parsed,cl_type}, this SDK uses a class with name CLValue, which is declared in "CLValue.kt" file under package "com.casper.sdk.clvalue", with main information like this:
 
```Perl
var itsBytes: String = ""
var itsParse: CLParsed = CLParsed()
var itsCLType: CLType = CLType()
```

This class also provide a supporter function to parse a JSON object to CLValue object.

When get information for a deploy, for example, the args of the payment/session or items in the execution_results can hold CLValue values, and they will be turned to CLValue object in Perl to support the work of storing information and doing the serialization.

### Example of declaring CLValue object

Take this CLValue in JSON

 ```Perl
 {
"bytes":"0400e1f505"
"parsed":"100000000"
"cl_type":"U512"
}
```

This JSON will turn to a CLValue like this:
 ```Perl
val oneCLValue = CLValue()
val oneCLType = CLType()
oneCLType.itsTypeStr = ConstValues.CLTYPE_U512
oneCLValue.itsCLType = oneCLType
val oneCLParse = CLParsed()
oneCLParse.itsCLType = oneCLType
oneCLParse.itsValueInStr = "100000000"
oneCLValue.itsParse = oneCLParse
oneCLValue.itsBytes = "0400e1f505"
```

Take this CLValue in JSON:

 ```Perl
 {
"bytes":"010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b"
"parsed":[
          [
             {
             "key":"token_uri"
             "value":"https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk"
             }
          ]
]
"cl_type":{
        "List":{
           "Map":{
           "key":"String"
           "value":"String"
           }
      }
}
 ```
Base on the deploy at this address: https://testnet.cspr.live/deploy/AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268 refer to session section of the deploy, args item number 2, here is the CLValue detail

<img width="831" alt="Screen Shot 2022-06-29 at 11 32 49" src="https://user-images.githubusercontent.com/94465107/176352315-502d6230-6a33-4165-a049-31a5671f890f.png">

This JSON will turn to a CLValue like this:
  
```Perl 
val oneCLValue = CLValue()
oneCLValue.itsBytes = "010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b"
//assignment for cl_type
val clType = CLType()
clType.itsTypeStr = ConstValues.CLTYPE_LIST
clType.innerCLType1.itsTypeStr = ConstValues.CLTYPE_MAP
clType.innerCLType1.innerCLType1 = CLType()
clType.innerCLType1.innerCLType2 = CLType()
clType.innerCLType1.innerCLType1.itsTypeStr = ConstValues.CLTYPE_STRING
clType.innerCLType1.innerCLType2.itsTypeStr = ConstValues.CLTYPE_STRING
oneCLValue.itsCLType = clType
//assignment for parsed
val mapParse = CLParsed()
mapParse.itsCLType.itsTypeStr = ConstValues.CLTYPE_MAP
val mapKey1 = CLParsed()
mapKey1.itsCLType.itsTypeStr = ConstValues.CLTYPE_STRING
mapKey1.itsValueInStr = "token_uri"
val mapValue1 = CLParsed()
mapValue1.itsCLType.itsTypeStr = ConstValues.CLTYPE_STRING
mapValue1.itsValueInStr = "https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk"
mapParse.innerParsed1 = CLParsed()
mapParse.innerParsed1.itsArrayValue.add(mapKey1)
mapParse.innerParsed2 = CLParsed()
mapParse.innerParsed2.itsArrayValue.add(mapValue1)
clParse.itsArrayValue.add(mapParse)
oneCLValue.itsParse = clParse

```
  
