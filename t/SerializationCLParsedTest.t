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
}
testCLParsedSerialization();