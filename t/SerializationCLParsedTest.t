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
	
	# CLParse U32 assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$clParsed->setItsCLType($clType);
	$clParsed->setItsValueStr("1024");
	$serialization = $serializationCLParsed->serializeFromCLParse($clParsed);
	print("u32 serialization is: ".$serialization."\n");
	ok($serialization eq "00040000","Test serialization for CLParsed U32(1024) value passed");
	
	
}
testCLParsedSerialization();