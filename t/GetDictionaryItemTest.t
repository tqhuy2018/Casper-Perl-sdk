#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 36;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);
use Common::ConstValues;
use GetDictionaryItem::GetDictionaryItemParams;
use GetDictionaryItem::GetDictionaryItemResult;
use GetDictionaryItem::GetDictionaryItemRPC;
use GetDictionaryItem::DictionaryIdentifier;
use GetDictionaryItem::DIAccountNamedKey;
use GetDictionaryItem::DIContractNamedKey;
use GetDictionaryItem::DIDictionary;
use GetDictionaryItem::DIURef;
# Test 1: Parameter DictionaryIdentifier of type AccountNamedKey
sub getDictionaryItem1 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIAccountNamedKey();
	$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
	$diANK->setDictionaryName("dict_name");
	$diANK->setDictionaryItemKey("abc_name");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("AccountNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
	ok($getDIResult->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok($getDIResult->getDictionaryKey() eq "dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373", "Test 1 dictionary key, Passed");
	ok(length($getDIResult->getMerkleProof()) == 30330, "Test 1 merkle proof, Passed");
	my $storedValue = $getDIResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_CLVALUE, "Test 1 Stored value of type CLValue");
	my $clValue = $storedValue->getItsValue();
	ok($clValue->getBytes() eq "090000006162635f76616c7565", "Test 1 CLValue bytes, Passed");
	ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING, "Test 1 CLValue cltype String, Passed");
	ok($clValue->getParse()->getItsValueStr() eq "abc_value", "Test 1 CLValue parsed, Passed");
}
# Test 2: Parameter DictionaryIdentifier of type ContractNamedKey
sub getDictionaryItem2 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIContractNamedKey();
	$diANK->setKey("hash-d5308670dc1583f49a516306a3eb719abe0ba51651cb08e606fcfc1f9b9134cf");
	$diANK->setDictionaryName("dictname");
	$diANK->setDictionaryItemKey("abcname");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("ContractNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
	ok($getDIResult->getApiVersion() eq "1.4.5", "Test 2 api version, Passed");
	ok($getDIResult->getDictionaryKey() eq "dictionary-ac34673fa957fa8083306892815496b8fdee0aa1509f0080823979d869176060", "Test 2 dictionary key, Passed");
	ok(length($getDIResult->getMerkleProof()) == 30178, "Test merkle proof, Passed");
	my $storedValue = $getDIResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_CLVALUE, "Test 2 Stored value of type CLValue");
	my $clValue = $storedValue->getItsValue();
	ok($clValue->getBytes() eq "0800000061626376616c7565", "Test 2 CLValue bytes, Passed");
	ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING, "Test 2 CLValue cltype String, Passed");
	ok($clValue->getParse()->getItsValueStr() eq "abcvalue", "Test 2 CLValue parsed, Passed");
}
# Test 3:  Parameter DictionaryIdentifier of type URef
sub getDictionaryItem3 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIURef();
	$diANK->setSeedUref("uref-30074a46a79b2d80cff437594d2422383f6c754de453b732448cc711b9f7e129-007");
	$diANK->setDictionaryItemKey("abc_name");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("URef");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
	ok($getDIResult->getApiVersion() eq "1.4.5", "Test 3 api version, Passed");
	ok($getDIResult->getDictionaryKey() eq "dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373", "Test 1 dictionary key, Passed");
	ok(length($getDIResult->getMerkleProof()) == 30330, "Test 3 merkle proof, Passed");
	my $storedValue = $getDIResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_CLVALUE, "Test 1 Stored value of type CLValue");
	my $clValue = $storedValue->getItsValue();
	ok($clValue->getBytes() eq "090000006162635f76616c7565", "Test 1 CLValue bytes, Passed");
	ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING, "Test 1 CLValue cltype String, Passed");
	ok($clValue->getParse()->getItsValueStr() eq "abc_value", "Test 1 CLValue parsed, Passed");
}
# Test 4:  Parameter DictionaryIdentifier of type Dictionary
sub getDictionaryItem4 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIDictionary();
	$diANK->setItsValue("dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("Dictionary");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
	ok($getDIResult->getApiVersion() eq "1.4.5", "Test 4 api version, Passed");
	ok($getDIResult->getDictionaryKey() eq "dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373", "Test 4 dictionary key, Passed");
	ok(length($getDIResult->getMerkleProof()) == 30330, "Test 4 merkle proof, Passed");
	my $storedValue = $getDIResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_CLVALUE, "Test 1 Stored value of type CLValue");
	my $clValue = $storedValue->getItsValue();
	ok($clValue->getBytes() eq "090000006162635f76616c7565", "Test 1 CLValue bytes, Passed");
	ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING, "Test 1 CLValue cltype String, Passed");
	ok($clValue->getParse()->getItsValueStr() eq "abc_value", "Test 1 CLValue parsed, Passed");
}
# Negative test: Test 5: Send parameter with wrong state root hash
sub getDictionaryItem5 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIAccountNamedKey();
	$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
	$diANK->setDictionaryName("dict_name");
	$diANK->setDictionaryItemKey("abc_name");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("AccountNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("AAA"); # THIS IS WRONG VALUE
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $error = $getDIRPC->getDictionaryItem($paramStr);
	ok($error->getErrorCode() eq "-32602", "Test error get dictionary item with wrong state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "Invalid params", "Test error get dictionary item with wrong state root hash, error is thrown, error message checked, Passed");
}
# Negative test: Test 6: Send parameter with wrong dictionary identifier of type AccountNamedKey - key parameter
sub getDictionaryItem6 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIAccountNamedKey();
	$diANK->setKey("account-hash-AAA"); # THIS IS WRONG VALUE
	$diANK->setDictionaryName("dict_name");
	$diANK->setDictionaryItemKey("abc_name");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("AccountNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8"); # THIS IS THE WRONG STATE ROOT HASH
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $error = $getDIRPC->getDictionaryItem($paramStr);
	ok($error->getErrorCode() eq "-32002", "Test error get dictionary item with wrong state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "Failed to parse key", "Test error get dictionary item with wrong state root hash, error is thrown, error message checked, Passed");
}
# Negative test: Test 7: Send parameter with wrong dictionary identifier of type AccountNamedKey - DictionaryName parameter
sub getDictionaryItem7 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIAccountNamedKey();
	$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
	$diANK->setDictionaryName("dict_name_AAA"); # THIS IS WRONG VALUE
	$diANK->setDictionaryItemKey("abc_name");
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("AccountNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8"); # THIS IS THE WRONG STATE ROOT HASH
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $error = $getDIRPC->getDictionaryItem($paramStr);
	ok($error->getErrorCode() eq "-32010", "Test error get dictionary item with wrong state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "Failed to get seed Uref", "Test error get dictionary item with wrong state root hash, error is thrown, error message checked, Passed");
}
# Negative test: Test 8: Send parameter with wrong dictionary identifier of type AccountNamedKey - DictionaryItemKey parameter
sub getDictionaryItem8 {
	my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
	my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
	my $diANK = new GetDictionaryItem::DIAccountNamedKey();
	$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
	$diANK->setDictionaryName("dict_name"); 
	$diANK->setDictionaryItemKey("abc_name_AAA"); # THIS IS WRONG VALUE
	my $di = new GetDictionaryItem::DictionaryIdentifier();
	$di->setItsType("AccountNamedKey");
	$di->setItsValue($diANK);
	$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8"); # THIS IS THE WRONG STATE ROOT HASH
	$getDIParams->setDictionaryIdentifier($di);
	my $paramStr = $getDIParams->generateParameterStr();
	my $error = $getDIRPC->getDictionaryItem($paramStr);
	ok($error->getErrorCode() eq "-32003", "Test error get dictionary item with wrong state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "state query failed: ValueNotFound(\"Failed to find base key at path: Key::Dictionary(3dbacaf669e6b4a3d2dbf25122d21070815215ad4573d1a355516616db6a7eab)\")", "Test error get dictionary item with wrong state root hash, error is thrown, error message checked, Passed");
}
getDictionaryItem1();
getDictionaryItem2();
getDictionaryItem3();
getDictionaryItem4();
getDictionaryItem5();
getDictionaryItem6();
getDictionaryItem7();
getDictionaryItem8();