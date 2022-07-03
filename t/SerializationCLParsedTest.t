#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 76;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Serialization::CLParseSerialization;
use CLValue::CLType;
use CLValue::CLParse;
use Common::ConstValues;


# Test 1: Call with block hash
sub testCLParsedSerialization {
	my $serializationCLParsed = new Serialization::CLParseSerialization();
	my $clType = new CLValue::CLType();
	my $clParsed = new CLValue::CLParse();
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	$clParsed->setItsCLType($clType);
	
	
	# CLParse Bool assertion
	
	$clParsed->setItsValueStr("true");
	my $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "01","Test serialization for CLParsed Bool true value passed");
	$clParsed->setItsValueStr("false");
    $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed Bool false value passed");
	
	# CLParse U8 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("0");
    $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed U8(0) value passed");
	
	$clParsed->setItsValueStr("9");
    $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "09","Test serialization for CLParsed U8(9) value passed");
	
	$clParsed->setItsValueStr("219");
    $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "db","Test serialization for CLParsed U8(219) value passed");
	
	$clParsed->setItsValueStr("255");
    $serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "ff","Test serialization for CLParsed U8(255) value passed");
	
	# CLParse I32 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00000000","Test serialization for CLParsed I32(0) value passed");
	
	$clParsed->setItsValueStr("-1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00fcffff","Test serialization for CLParsed I32(-1024) value passed");
	
	$clParsed->setItsValueStr("-3333");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "fbf2ffff","Test serialization for CLParsed I32(-3333) value passed");
	
	$clParsed->setItsValueStr("1000");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "e8030000","Test serialization for CLParsed I32(1000) value passed");
	
	$clParsed->setItsValueStr("5005");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "8d130000","Test serialization for CLParsed I32(5005) value passed");
	
	$clParsed->setItsValueStr("12764");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "dc310000","Test serialization for CLParsed I32(12764) value passed");
	
	$clParsed->setItsValueStr("-12369");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "afcfffff","Test serialization for CLParsed I32(-12369) value passed");
	
	# CLParse I64 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_I64);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0000000000000000","Test serialization for CLParsed I64(0) value passed");
	
	$clParsed->setItsValueStr("-1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00fcffffffffffff","Test serialization for CLParsed I64(-1024) value passed");
	
	$clParsed->setItsValueStr("1000");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "e803000000000000","Test serialization for CLParsed I64(1000) value passed");
	
	$clParsed->setItsValueStr("-123456789");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "eb32a4f8ffffffff","Test serialization for CLParsed I64(-123456789) value passed");
	
	$clParsed->setItsValueStr("-56789");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "2b22ffffffffffff","Test serialization for CLParsed I64(-56789) value passed");
	
	$clParsed->setItsValueStr("56789");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "d5dd000000000000","Test serialization for CLParsed I64(56789) value passed");
	
	# CLParse U32 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00040000","Test serialization for CLParsed U32(1024) value passed");
	
	$clParsed->setItsValueStr("5531024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "90655400","Test serialization for CLParsed U32(5531024) value passed");
	
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00000000","Test serialization for CLParsed U32(0) value passed");
	
	$clParsed->setItsValueStr("334455");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "771a0500","Test serialization for CLParsed U32(334455) value passed");
	
	$clParsed->setItsValueStr("4099");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "03100000","Test serialization for CLParsed U32(03100000) value passed");
	
	# CLParse U64 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0004000000000000","Test serialization for CLParsed U64(1024) value passed");
	
	$clParsed->setItsValueStr("33009900995531024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "10d1e87e54467500","Test serialization for CLParsed U64(33009900995531024) value passed");
	
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0000000000000000","Test serialization for CLParsed U64(0) value passed");
	
	$clParsed->setItsValueStr("300000");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "e093040000000000","Test serialization for CLParsed U64(300000) value passed");
	
	$clParsed->setItsValueStr("123456789");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "15cd5b0700000000","Test serialization for CLParsed U64(123456789) value passed");
	
	# CLParse U128 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U128);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("123456789101112131415");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0957ff1ada959f4eb106","Test serialization for CLParsed U128(123456789101112131415) value passed");
	
	$clParsed->setItsValueStr("1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "020004","Test serialization for CLParsed U128(1024) value passed");
	
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed U128(0) value passed");
	
	# CLParse U256 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U256);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("999988887777666655556666777888999");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0ee76837d2ca215879f7bc5ca24d31","Test serialization for CLParsed U256(999988887777666655556666777888999) value passed");
	
	$clParsed->setItsValueStr("2048");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "020008","Test serialization for CLParsed U256(2048) value passed");
	
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed U256(0) value passed");
	
	# CLParse U512 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("999888666555444999887988887777666655556666777888999666999");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "1837f578fca55492f299ea354eaca52b6e9de47d592453c728","Test serialization for CLParsed U512(999888666555444999887988887777666655556666777888999666999) value passed");
	
	$clParsed->setItsValueStr("4096");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "020010","Test serialization for CLParsed U512(4096) value passed");
	
	$clParsed->setItsValueStr("100000000");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0400e1f505","Test serialization for CLParsed U512(100000000) value passed");
	
	$clParsed->setItsValueStr("0");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed U512(0) value passed");
	
	# CLParse String assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("Hello, World!");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0d00000048656c6c6f2c20576f726c6421","Test serialization for CLParsed String(Hello, World!) value passed");
	
	$clParsed->setItsValueStr("lWJWKdZUEudSakJzw1tn");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "140000006c574a574b645a5545756453616b4a7a7731746e","Test serialization for CLParsed String(lWJWKdZUEudSakJzw1tn) value passed");

	$clParsed->setItsValueStr("S1cXRT3E1jyFlWBAIVQ8");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "140000005331635852543345316a79466c57424149565138","Test serialization for CLParsed String(S1cXRT3E1jyFlWBAIVQ8) value passed");

	$clParsed->setItsValueStr("123456789123456789123456789123456789123456789123456789");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "36000000313233343536373839313233343536373839313233343536373839313233343536373839313233343536373839313233343536373839","Test serialization for CLParsed String(123456789123456789123456789123456789123456789123456789) value passed");

	$clParsed->setItsValueStr("target");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "06000000746172676574","Test serialization for CLParsed String(target) value passed");
	
	$clParsed->setItsValueStr("Weather");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0700000057656174686572","Test serialization for CLParsed String(Weather) value passed");
	
	$clParsed->setItsValueStr("aa");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "020000006161","Test serialization for CLParsed String(aa) value passed");
	
	$clParsed->setItsValueStr("I want to know, really!");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "17000000492077616e7420746f206b6e6f772c207265616c6c7921","Test serialization for CLParsed String(I want to know, really!) value passed");
	
	# Unit assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_UNIT);
	$clParsed->setItsCLType($clType);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "","Test serialization for CLParsed Unit value passed");
	
	# Key assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269","Test serialization for CLParsed Key(Account Hash) value passed");
	
	$clParsed->setItsValueStr("hash-8cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "018cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401","Test serialization for CLParsed Key(Hash) value passed");

	$clParsed->setItsValueStr("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "02be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607","Test serialization for CLParsed Key(URef) value passed");
	
	$clParsed->setItsValueStr("abcdef");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq $Common::ConstValues::INVALID_VALUE,"Test negative serialization for CLParsed Key(abcdef) value passed");
	
	# URef assertion	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_UREF);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "02be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607","Test serialization for CLParsed URef value passed");
	
	$clParsed->setItsValueStr("uref-8cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401-007");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "028cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae440107","Test serialization for CLParsed URef value passed");
	
	$clParsed->setItsValueStr("hash-8cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401-007");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq $Common::ConstValues::INVALID_VALUE,"Test negative serialization for CLParsed URef value passed");
	
	# PublicKey assertion
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("01394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "01394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b","Test serialization for CLParsed PublicKey value passed");
	
	$clParsed->setItsValueStr("abc8de76bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fcec");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "abc8de76bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fcec","Test serialization for CLParsed PublicKey value passed");
	
	# Option assertion
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	$clParsed->setItsCLType($clType);
	
	# Option(Null) assertion
	$clParsed->setItsValueStr($Common::ConstValues::NULL_VALUE);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed Option(NULL) value passed");
	
	# Option(U32(10)) assertion
	my $clParsedInner1 = new CLValue::CLParse();
	my $clTypeInner1 = new CLValue::CLType();
	$clTypeInner1->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$clType->setInnerCLType1($clTypeInner1);
	$clParsed->setItsCLType($clType);
	$clParsedInner1->setItsCLType($clTypeInner1);
	$clParsedInner1->setItsValueStr("10");
	$clParsed->setInnerParse1($clParsedInner1);
	$clParsed->setItsValueStr("ok");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "010a000000","Test serialization for CLParsed Option(U32(10)) value passed");
	
	# Option(U64(123456)) assertion
	$clTypeInner1->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$clType->setInnerCLType1($clTypeInner1);
	$clParsed->setItsCLType($clType);
	$clParsedInner1->setItsCLType($clTypeInner1);
	$clParsedInner1->setItsValueStr("123456");
	$clParsed->setInnerParse1($clParsedInner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "0140e2010000000000","Test serialization for CLParsed Option(U64(123456)) value passed");
	
	# Option(String("Hello, World!")) assertion
	$clTypeInner1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clType->setInnerCLType1($clTypeInner1);
	$clParsed->setItsCLType($clType);
	$clParsedInner1->setItsCLType($clTypeInner1);
	$clParsedInner1->setItsValueStr("Hello, World!");
	$clParsed->setInnerParse1($clParsedInner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	ok($serialization eq "010d00000048656c6c6f2c20576f726c6421","Test serialization for CLParsed Option(String(Hello, World!)) value passed");
	
	# List assertion
	# Empty list assertion
	my $clParsed2 = new CLValue::CLParse();
	my $clType2 = new CLValue::CLType();
	$clType2->setItsTypeStr($Common::ConstValues::CLTYPE_LIST);
	$clParsed2->setItsCLType($clType2);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed2);
	ok($serialization eq "","Test serialization for CLParsed List(empty) value passed");
	
	# List of 3 CLParse U32 number assertion
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
	$clParsed2->setItsValueList(@listValue);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed2);
	ok($serialization eq "03000000010000000200000003000000","Test serialization for CLParsed List(U32) value passed");
	
	# List of 3 CLParse String assertion
	
	$clTypeList1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParseList1->setItsCLType($clTypeList1);
	$clParseList1->setItsValueStr("Hello, World!");
	# Second U32
	$clParseList2->setItsCLType($clTypeList1);
	$clParseList2->setItsValueStr("Bonjour le monde");
	# Third U32 
	$clParseList3->setItsCLType($clTypeList1);
	$clParseList3->setItsValueStr("Hola Mundo");
	@listValue = ();
	@listValue = ($clParseList1,$clParseList2,$clParseList3);
	$clParsed2->setItsValueList(@listValue);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed2);
	ok($serialization eq "030000000d00000048656c6c6f2c20576f726c642110000000426f6e6a6f7572206c65206d6f6e64650a000000486f6c61204d756e646f","Test serialization for CLParsed List(String) value passed");
	
	# List of 3 CLParse U8 assertion
	
	$clTypeList1->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
	$clParseList1->setItsCLType($clTypeList1);
	$clParseList1->setItsValueStr("100");
	# Second U32
	$clParseList2->setItsCLType($clTypeList1);
	$clParseList2->setItsValueStr("0");
	# Third U32 
	$clParseList3->setItsCLType($clTypeList1);
	$clParseList3->setItsValueStr("255");
	@listValue = ();
	@listValue = ($clParseList1,$clParseList2,$clParseList3);
	$clParsed2->setItsValueList(@listValue);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed2);
	ok($serialization eq "030000006400ff","Test serialization for CLParsed List(U8) value passed");
	
=comment
List(Map(String,String) assertion
base on the deploy at this address: https://testnet.cspr.live/deploy/AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268
refer to session section of the deploy, args item number 2
=cut 


	# CLParse Map assertion
=comment
	CLParse Map(String,String) assertion
	Test based on the deploy at this address
	https://testnet.cspr.live/deploy/430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e
	please refer to execution_results item 86 to see the real data
=cut
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
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedMap);
	ok($serialization eq "0400000015000000636f6e74726163745f7061636b6167655f6861736840000000643332444531353263306242464463414666356232613630373043643732394663304633656143463330306136623565326162414230333530323743343962630a0000006576656e745f747970650400000073796e630800000072657365727665301800000034313239343931343739373335363933323135333637343708000000726573657276653118000000393931373137313437323638353639383438313432343138","Test serialization for CLParsed Map(String,String) value passed");

=comment
Map(String,String) 2
Test based on the deploy at this address
https://testnet.cspr.live/deploy/93b24bf34eba63a157b60b696eae83424904263679dff1cd1c8d6d3f3d73afaa
please refer to execution_results item 30 to see the real data
Key generation
=cut 
	# Key generation
	# First key
	$clParseMapKey1->setItsValueStr("contract_package_hash");
	# Second key
	$clParseMapKey2->setItsValueStr("event_type");
	# Third key
	$clParseMapKey3->setItsValueStr("from");
	# Fourth key
	$clParseMapKey4->setItsValueStr("pair");
	# Fifth key
	my $clParseMapKey5 = new CLValue::CLParse();
	$clParseMapKey5->setItsCLType($clTypeMapKey);
	$clParseMapKey5->setItsValueStr("to");
	# Sixth key
	my $clParseMapKey6 = new CLValue::CLParse();
	$clParseMapKey6->setItsCLType($clTypeMapKey);
	$clParseMapKey6->setItsValueStr("value");
	# Map Key assignment
	@listKey = ();
	@listKey = ($clParseMapKey1,$clParseMapKey2,$clParseMapKey3,$clParseMapKey4,$clParseMapKey5,$clParseMapKey6);
	$innerParseKey->setItsValueList(@listKey);
	$clParsedMap->setInnerParse1($innerParseKey);
	# Value generation
	# First value
	$clParseMapValue1->setItsValueStr("26526c30383e5c02d684ac68d7845e576a87166926f7500bdaa303cdab52aea7");
	# Second value
	$clParseMapValue2->setItsValueStr("transfer");
	# Third value
	$clParseMapValue3->setItsValueStr("Key::Account(8b217a09296d5ce360847a7d20f623476157c5f022333c4e988a464035cadd80)");
	# Fourth value
	$clParseMapValue4->setItsValueStr("Key::Hash(53a8121f219ad2c6420f007a2016ed320c519579112b81d505cb15715404b264)");
	# Fifth value
	my $clParseMapValue5 = new CLValue::CLParse();
	$clParseMapValue5->setItsCLType($clTypeMapValue);
	$clParseMapValue5->setItsValueStr("Key::Hash(26526c30383e5c02d684ac68d7845e576a87166926f7500bdaa303cdab52aea7)");
	# Sixth value
	my $clParseMapValue6 = new CLValue::CLParse();
	$clParseMapValue6->setItsCLType($clTypeMapValue);
	$clParseMapValue6->setItsValueStr("1763589511");
	# Map Key assignment
	@listValue = ();
	@listValue = ($clParseMapValue1,$clParseMapValue2,$clParseMapValue3,$clParseMapValue4,$clParseMapValue5,$clParseMapValue6);
	$innerParseValue->setItsValueList(@listValue);
	$clParsedMap->setInnerParse2($innerParseValue);	
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedMap);
	ok($serialization eq "0600000015000000636f6e74726163745f7061636b6167655f6861736840000000323635323663333033383365356330326436383461633638643738343565353736613837313636393236663735303062646161333033636461623532616561370a0000006576656e745f74797065080000007472616e736665720400000066726f6d4e0000004b65793a3a4163636f756e7428386232313761303932393664356365333630383437613764323066363233343736313537633566303232333333633465393838613436343033356361646438302904000000706169724b0000004b65793a3a4861736828353361383132316632313961643263363432306630303761323031366564333230633531393537393131326238316435303563623135373135343034623236342902000000746f4b0000004b65793a3a486173682832363532366333303338336535633032643638346163363864373834356535373661383731363639323666373530306264616133303363646162353261656137290500000076616c75650a00000031373633353839353131","Test serialization for CLParsed Map(String,String) 2 value passed");
	
	# CLParse ByteArray assertion
	my $clParseByteArray = new CLValue::CLParse();
	my $clTypeByteArray = new CLValue::CLType();
	$clTypeByteArray->setItsTypeStr($Common::ConstValues::CLTYPE_BYTEARRAY);
	$clParseByteArray->setItsCLType($clTypeByteArray);
	$clParseByteArray->setItsValueStr("006d0be2fb64bcc8d170443fbadc885378fdd1c71975e2ddd349281dd9cc59cc");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParseByteArray);
	ok($serialization eq "006d0be2fb64bcc8d170443fbadc885378fdd1c71975e2ddd349281dd9cc59cc","Test serialization for CLParsed ByteArray value passed");
	
	# Test for CLValue Any serialization
	my $clParseAny = new CLValue::CLParse();
	my $clTypeAny = new CLValue::CLType();
	$clTypeAny->setItsTypeStr($Common::ConstValues::CLTYPE_ANY);
	$clParseAny->setItsCLType($clTypeAny);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParseAny);
	ok($serialization eq $Common::ConstValues::PURE_NULL,"Test serialization for CLParsed Any value passed");
	
	# Test for CLValue Result serialization
	my $clParseResult = new CLValue::CLParse();
	my $clTypeResult = new CLValue::CLType();
	$clTypeResult->setItsTypeStr($Common::ConstValues::CLTYPE_RESULT);
	$clParseResult->setItsCLType($clTypeResult);
=comment
For Result Ok(String)
Take this deploy address https://testnet.cspr.live/deploy/2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61
in execution_results item 16
=cut
	$clParseResult->setItsValueStr($Common::ConstValues::CLPARSED_RESULT_OK);
	my $clParseResultInner1 = new CLValue::CLParse();
	my $clTypeResultInner1 = new CLValue::CLType();
	$clTypeResultInner1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParseResultInner1->setItsCLType($clTypeResultInner1);
	$clParseResultInner1->setItsValueStr("goodresult");
	$clParseResult->setInnerParse1($clParseResultInner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParseResult);
	ok($serialization eq "010a000000676f6f64726573756c74","Test serialization for CLParsed Result(Ok(String)) value passed");
	
	# For Result Err(U512)
	$clParseResult->setItsValueStr($Common::ConstValues::CLPARSED_RESULT_ERR);
	$clTypeResultInner1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clParseResultInner1->setItsCLType($clTypeResultInner1);
	$clParseResultInner1->setItsValueStr("999888666555444999887988887777666655556666777888999666999");
	$clParseResult->setInnerParse1($clParseResultInner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParseResult);
	ok($serialization eq "001837f578fca55492f299ea354eaca52b6e9de47d592453c728","Test serialization for CLParsed Result(Err(U512)) value passed");
=comment
For Result Err2
Take this deploy address https://testnet.cspr.live/deploy/2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61
in execution_results item 21
=cut
	$clParseResult->setItsValueStr($Common::ConstValues::CLPARSED_RESULT_ERR);
	$clTypeResultInner1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParseResultInner1->setItsCLType($clTypeResultInner1);
	$clParseResultInner1->setItsValueStr("badresult");
	$clParseResult->setInnerParse1($clParseResultInner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParseResult);
	ok($serialization eq "0009000000626164726573756c74","Test serialization for CLParsed Result(Err(String)) value passed");

	# CLValue Tuple1 serialization
	
	my $clParsedTuple1 = new CLValue::CLParse();
	my $clTypeTuple1 = new CLValue::CLType();
	$clTypeTuple1->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE1);
	$clParsedTuple1->setItsCLType($clTypeTuple1);
	
	# CLParse Tuple1(I32(1000)) assertion
	my $clParsedTuple1Inner1 = new CLValue::CLParse();
	my $clTypeTuple1Inner1 = new CLValue::CLType();
	$clTypeTuple1Inner1->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clParsedTuple1Inner1->setItsCLType($clTypeTuple1Inner1);
	$clParsedTuple1Inner1->setItsValueStr("1000");
	$clParsedTuple1->setInnerParse1($clParsedTuple1Inner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedTuple1);
	ok($serialization eq "e8030000","Test serialization for CLParsed Tuple1(I32) value passed");
	
	# CLParse Tuple1(String("Hello, World!")) assertion
	$clTypeTuple1Inner1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParsedTuple1Inner1->setItsCLType($clTypeTuple1Inner1);
	$clParsedTuple1Inner1->setItsValueStr("Hello, World!");
	$clParsedTuple1->setInnerParse1($clParsedTuple1Inner1);
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedTuple1);
	ok($serialization eq "0d00000048656c6c6f2c20576f726c6421","Test serialization for CLParsed Tuple1(String) value passed");
	
	# CLParse Tuple2 assertion
=comment
CLParse Tuple2 assertion
Tuple2(String("abc"),U512(1)) assertion
Take this deploy address https://testnet.cspr.live/deploy/2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61
in execution_results item 31
=cut
	my $clParsedTuple2 = new CLValue::CLParse();
	my $clTypeTuple2 = new CLValue::CLType();
	$clTypeTuple2->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE2);
	$clParsedTuple2->setItsCLType($clTypeTuple2);
	
	my $clParsedTuple2Inner1 = new CLValue::CLParse();
	my $clTypeTuple2Inner1 = new CLValue::CLType();
	$clTypeTuple2Inner1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParsedTuple2Inner1->setItsCLType($clTypeTuple2Inner1);
	$clParsedTuple2Inner1->setItsValueStr("abc");
	$clParsedTuple2->setInnerParse1($clParsedTuple2Inner1);
	
	my $clParsedTuple2Inner2 = new CLValue::CLParse();
	my $clTypeTuple2Inner2 = new CLValue::CLType();
	$clTypeTuple2Inner2->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clParsedTuple2Inner2->setItsCLType($clTypeTuple2Inner2);
	$clParsedTuple2Inner2->setItsValueStr("1");
	$clParsedTuple2->setInnerParse2($clParsedTuple2Inner2);
	
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedTuple2);
	ok($serialization eq "030000006162630101","Test serialization for CLParsed Tuple2(String,U512) value passed");
	
	# CLParse Tuple3 assertion
=comment
CLParse Tuple3 assertion
Tuple3(PublicKey,Option,U512) assertion
Take this deploy address https://testnet.cspr.live/deploy/2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61
in execution_results item 36
=cut
	my $clParsedTuple3 = new CLValue::CLParse();
	my $clTypeTuple3 = new CLValue::CLType();
	$clTypeTuple3->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE3);
	$clParsedTuple3->setItsCLType($clTypeTuple3);
	
	my $clParsedTuple3Inner1 = new CLValue::CLParse();
	my $clTypeTuple3Inner1 = new CLValue::CLType();
	$clTypeTuple3Inner1->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$clParsedTuple3Inner1->setItsCLType($clTypeTuple3Inner1);
	$clParsedTuple3Inner1->setItsValueStr("01a018bf278f32fdb7b06226071ce399713ace78a28d43a346055060a660ba7aa9");
	$clParsedTuple3->setInnerParse1($clParsedTuple3Inner1);
	
	my $clParsedTuple3Inner2 = new CLValue::CLParse();
	my $clTypeTuple3Inner2 = new CLValue::CLType();
	$clTypeTuple3Inner2->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	$clParsedTuple3Inner2->setItsCLType($clTypeTuple3Inner2);
	$clParsedTuple3Inner2->setItsValueStr("ok");
	my $clParseTuple3OptionInner = new CLValue::CLParse();
	my $clTypeTuple3OptionInner = new CLValue::CLType();
	$clTypeTuple3OptionInner->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clParseTuple3OptionInner->setItsCLType($clTypeTuple3OptionInner);
	$clParseTuple3OptionInner->setItsValueStr("abc");
	$clParsedTuple3Inner2->setInnerParse1($clParseTuple3OptionInner);
	$clParsedTuple3->setInnerParse2($clParsedTuple3Inner2);
	
	my $clParsedTuple3Inner3 = new CLValue::CLParse();
	my $clTypeTuple3Inner3 = new CLValue::CLType();
	$clTypeTuple3Inner3->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clParsedTuple3Inner3->setItsCLType($clTypeTuple3Inner3);
	$clParsedTuple3Inner3->setItsValueStr("2");
	$clParsedTuple3->setInnerParse3($clParsedTuple3Inner3);
	
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsedTuple3);
	ok($serialization eq "01a018bf278f32fdb7b06226071ce399713ace78a28d43a346055060a660ba7aa901030000006162630102","Test serialization for CLParsed Tuple3(PublicKey,Option(String),U512) value passed");
}

testCLParsedSerialization();