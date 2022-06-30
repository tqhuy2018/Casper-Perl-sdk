#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 34;
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
	
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "16","Test serialization for CLType PUBLIC_KEY passed");
	
	# Option CLType assertion
	
	# Option(U512) assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $innerType1  = new CLValue::CLType();
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clType->setInnerCLType1($innerType1);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0d08","Test serialization for CLType OPTION(U512) passed");
	
	# Option(Bool) assertion
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	$clType->setInnerCLType1($innerType1);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0d00","Test serialization for CLType OPTION(Bool) passed");
	
	# Option(I32) assertion
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clType->setInnerCLType1($innerType1);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0d01","Test serialization for CLType OPTION(I32) passed");
	
	# Map CLType assertion
	
	# Map(String,String) assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_MAP);
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clType->setInnerCLType1($innerType1);
	my $innerType2  = new CLValue::CLType();
	$innerType2->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clType->setInnerCLType2($innerType2);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "110a0a","Test serialization for CLType Map(String,String) passed");
	
	# Map(U512,I32) assertion
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$clType->setInnerCLType1($innerType1);
	$innerType2->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clType->setInnerCLType2($innerType2);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "110801","Test serialization for CLType Map(U512,I32) passed");
	
	# List CLType assertion
	
	# List(Bool) assertion
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_LIST);
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	$clType->setInnerCLType1($innerType1);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0e00","Test serialization for CLType List(Bool) passed");
	
	# List(Key) assertion
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
	$clType->setInnerCLType1($innerType1);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0e0b","Test serialization for CLType List(Key) passed");
	
	# List(Map(String,String)) assertion
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_MAP);
	$clType->setInnerCLType1($innerType1);
	my $clTypeMapKey = new CLValue::CLType();
	$clTypeMapKey->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	my $clTypeMapValue = new CLValue::CLType();
	$clTypeMapValue->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$innerType1->setInnerCLType1($clTypeMapKey);
	$innerType1->setInnerCLType2($clTypeMapValue);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0e110a0a","Test serialization for CLType List(Map(String,String)) passed");
	
	# List(Map(Bool,Option(U128))) assertion
	
	$clTypeMapKey->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	$clTypeMapValue->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $clValueInner1 = new CLValue::CLType();
	$clValueInner1->setItsTypeStr($Common::ConstValues::CLTYPE_U128);
	$clTypeMapValue->setInnerCLType1($clValueInner1);
	$innerType1->setInnerCLType1($clTypeMapKey);
	$innerType1->setInnerCLType2($clTypeMapValue);
	$serialization = $serializationCLType->serializeForCLType($clType);
	ok($serialization eq "0e11000d06","Test serialization for CLType List(Map(Bool,Option(U128))) passed");
	
	# Result CLType assertion
	# Result(Ok(I64),Err(PublicKey))
	my $clType2 = new CLValue::CLType();
	$clType2->setItsTypeStr($Common::ConstValues::CLTYPE_RESULT);
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_I64);
	$clType2->setInnerCLType1($innerType1);
	$innerType2->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$clType2->setInnerCLType2($innerType2);
	$serialization = $serializationCLType->serializeForCLType($clType2);
	ok($serialization eq "100216","Test serialization for CLType Result(Ok(I64),Err(PublicKey)) passed");
	
	# Result(Ok(Option(U256),Err(Option(U32))
	$innerType1->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $clValueOption1 = new CLValue::CLType();
	$clValueOption1->setItsTypeStr($Common::ConstValues::CLTYPE_U256);
	$innerType1->setInnerCLType1($clValueOption1);
	$clType2->setInnerCLType1($innerType1);
	$innerType2->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $clValueOption2 = new CLValue::CLType();
	$clValueOption2->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$innerType2->setInnerCLType1($clValueOption2);
	$clType2->setInnerCLType2($innerType2);
	$serialization = $serializationCLType->serializeForCLType($clType2);
	ok($serialization eq "100d070d04","Test serialization for CLType Result(Ok(Option(U256),Err(Option(U32)) passed");
	
	# Tuple1 CLType assertion
	
	# Tuple1(Any) assertion
	my $clType3 = new CLValue::CLType();
	$clType3->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE1);
	my $innerType31 = new CLValue::CLType();
	$innerType31->setItsTypeStr($Common::ConstValues::CLTYPE_ANY);
	$clType3->setInnerCLType1($innerType31);
	$serialization = $serializationCLType->serializeForCLType($clType3);
	ok($serialization eq "1215","Test serialization for CLType Tuple1(Any) passed");
	
	# Tuple1(Key) assertion
	$innerType31->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
	$clType3->setInnerCLType1($innerType31);
	$serialization = $serializationCLType->serializeForCLType($clType3);
	ok($serialization eq "120b","Test serialization for CLType Tuple1(Any) passed");
	
	# Tuple1(Option(String)) assertion
	$innerType31->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
	my $innerType31Inner = new CLValue::CLType();
	$innerType31Inner->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$innerType31->setInnerCLType1($innerType31Inner);
	$clType3->setInnerCLType1($innerType31);
	$serialization = $serializationCLType->serializeForCLType($clType3);
	ok($serialization eq "120d0a","Test serialization for CLType Tuple1(Any) passed");
	
	# Tuple2 CLType assertion
	
	# Tuple2(I32,I64) assertion
	my $clType4 = new CLValue::CLType();
	$clType4->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE2);
	my $innerType41 = new CLValue::CLType();
	$innerType41->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clType4->setInnerCLType1($innerType41);
	my $innerType42 = new CLValue::CLType();
	$innerType42->setItsTypeStr($Common::ConstValues::CLTYPE_I64);
	$clType4->setInnerCLType2($innerType42);
	$serialization = $serializationCLType->serializeForCLType($clType4);
	ok($serialization eq "130102","Test serialization for CLType Tuple2(I32,I64) passed");
	
	# Tuple2(U64,String) assertion
	$innerType41->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$clType4->setInnerCLType1($innerType41);
	$innerType42->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clType4->setInnerCLType2($innerType42);
	$serialization = $serializationCLType->serializeForCLType($clType4);
	ok($serialization eq "13050a","Test serialization for CLType  Tuple2(U64,String) passed");
	
	# Tuple2(Result(Ok(U8),Err(Unit)),URef) assertion
	$innerType41->setItsTypeStr($Common::ConstValues::CLTYPE_RESULT);
	my $innerResult4OK  = new CLValue::CLType();
	$innerResult4OK->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
	$innerType41->setInnerCLType1($innerResult4OK);
	my $innerResult4Err  = new CLValue::CLType();
	$innerResult4Err->setItsTypeStr($Common::ConstValues::CLTYPE_UNIT);
	$innerType41->setInnerCLType2($innerResult4Err);
	$clType4->setInnerCLType1($innerType41);
	$innerType42->setItsTypeStr($Common::ConstValues::CLTYPE_UREF);
	$clType4->setInnerCLType2($innerType42);
	$serialization = $serializationCLType->serializeForCLType($clType4);
	ok($serialization eq "131003090c","Test serialization for CLType Tuple2(Result(Ok(U8),Err(Unit)),URef) passed");
	
	# Tuple3 CLType assertion
	
    # Tuple3(Bool,I32,I64) assertion
    
    my $clType5 = new CLValue::CLType();
	$clType5->setItsTypeStr($Common::ConstValues::CLTYPE_TUPLE3);
	my $innerType51 = new CLValue::CLType();
	$innerType51->setItsTypeStr($Common::ConstValues::CLTYPE_BOOL);
	$clType5->setInnerCLType1($innerType51);
	my $innerType52 = new CLValue::CLType();
	$innerType52->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$clType5->setInnerCLType2($innerType52);
	my $innerType53 = new CLValue::CLType();
	$innerType53->setItsTypeStr($Common::ConstValues::CLTYPE_I64);
	$clType5->setInnerCLType3($innerType53);
	$serialization = $serializationCLType->serializeForCLType($clType5);
	ok($serialization eq "14000102","Test serialization for CLType  Tuple3(Bool,I32,I64) passed");
	
	# Tuple3 (String,Key,PublicKey)
	$innerType51->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$clType5->setInnerCLType1($innerType51);
	$innerType52->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
	$clType5->setInnerCLType2($innerType52);
	$innerType53->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$clType5->setInnerCLType3($innerType53);
	$serialization = $serializationCLType->serializeForCLType($clType5);
	ok($serialization eq "140a0b16","Test serialization for CLType  Tuple3 (String,Key,PublicKey) passed");
	
	# Tuple3(List(Any),Map(U8,I32),Result(String))
	# List(Any) setup
	$innerType51->setItsTypeStr($Common::ConstValues::CLTYPE_LIST);
	my $inner51List = new CLValue::CLType();
	$inner51List->setItsTypeStr($Common::ConstValues::CLTYPE_ANY);
	$innerType51->setInnerCLType1($inner51List);
	$clType5->setInnerCLType1($innerType51);
	# Map(U8,I32) setup
	
	$innerType52->setItsTypeStr($Common::ConstValues::CLTYPE_MAP);
	# Key setup
	my $inner52Key = new CLValue::CLType();
	$inner52Key->setItsTypeStr($Common::ConstValues::CLTYPE_U8);
	$innerType52->setInnerCLType1($inner52Key);
	# Value setup
	my $inner52Value = new CLValue::CLType();
	$inner52Value->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$innerType52->setInnerCLType2($inner52Value);
	$clType5->setInnerCLType2($innerType52);
	# Result(String,U512) setup
	
	$innerType53->setItsTypeStr($Common::ConstValues::CLTYPE_RESULT);
	# Ok setup
	my $inner53Ok = new CLValue::CLType();
	$inner53Ok->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$innerType53->setInnerCLType1($inner53Ok);
	# Err setup
	my $inner53Err = new CLValue::CLType();
	$inner53Err->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$innerType53->setInnerCLType2($inner53Err);
	$clType5->setInnerCLType3($innerType53);
	$serialization = $serializationCLType->serializeForCLType($clType5);
	ok($serialization eq "140e15110301100a08","Test serialization for CLType  Tuple3(List(Any),Map(U8,I32),Result(String)) passed");
}

testCLTypeSerialization();