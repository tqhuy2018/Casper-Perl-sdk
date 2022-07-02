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
	
}
testCLParsedSerialization();