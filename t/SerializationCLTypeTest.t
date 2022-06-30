#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 76;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Serialization::CLTypeSerialization;
use CLValue::CLType;
use Common::ConstValues;


# Test 1: Call with block hash
sub testCLTypeSerialization {
	my $serializationCLType = new Serialization::CLTypeSerialization();
	my $clType = new CLValue::CLType();
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	my $serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "00","Test serialization for CLType Bool passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "01","Test serialization for CLType I32 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_I64);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "02","Test serialization for CLType I64 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "03","Test serialization for CLType U8 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "04","Test serialization for CLType U32 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "05","Test serialization for CLType U64 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U128);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "06","Test serialization for CLType U128 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U256);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "07","Test serialization for CLType U256 passed");

	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "08","Test serialization for CLType U512 passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_UNIT);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "09","Test serialization for CLType UNIT passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0a","Test serialization for CLType STRING passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0b","Test serialization for CLType KEY passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_UREF);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0c","Test serialization for CLType UREF passed");
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $innerType1  = new CLValue::CLType();
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	print("ineert type 1 is:".$innerType1->getItsTypeStr()."\n");
	$clType->setInnerCLType1($innerType1);
	my $clTypeInner1 = $clType->getInnerCLType1();
	print("clType 1 is: " . $clTypeInner1->getItsTypeStr()."\n");
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0d08","Test serialization for CLType OPTION passed");

}

testCLTypeSerialization();