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
	
	# CLParse Bool assertion
	my $clParsed = new CLValue::CLParse();
	$clParsed->setItsValueStr("true");
	my $serialization = $serializationCLParsed->serializeFromCLParseBool($clParsed);
	ok($serialization eq "01","Test serialization for CLParsed Bool true value passed");
	$clParsed->setItsValueStr("false");
    $serialization = $serializationCLParsed->serializeFromCLParseBool($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed Bool false value passed");
	
	# CLParse U8 assertion
	$clParsed->setItsValueStr("0");
    $serialization = $serializationCLParsed->serializeFromCLParseU8($clParsed);
	ok($serialization eq "00","Test serialization for CLParsed U8(0) value passed");
	
	$clParsed->setItsValueStr("9");
    $serialization = $serializationCLParsed->serializeFromCLParseU8($clParsed);
	ok($serialization eq "09","Test serialization for CLParsed U8(9) value passed");
	
	$clParsed->setItsValueStr("219");
    $serialization = $serializationCLParsed->serializeFromCLParseU8($clParsed);
	ok($serialization eq "db","Test serialization for CLParsed U8(219) value passed");
	
	$clParsed->setItsValueStr("255");
    $serialization = $serializationCLParsed->serializeFromCLParseU8($clParsed);
	ok($serialization eq "ff","Test serialization for CLParsed U8(255) value passed");
}
testCLParsedSerialization();