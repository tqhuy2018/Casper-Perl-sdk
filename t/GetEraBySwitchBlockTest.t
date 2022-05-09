#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 59;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

use Common::ConstValues;
use GetEraInfoBySwitchBlock::GetEraInfoBySwitchBlockRPC;
use GetEraInfoBySwitchBlock::GetEraInfoResult;
use Common::BlockIdentifier;

sub getEraInfo {
	my $getEra = new GetEraInfoBySwitchBlock::GetEraInfoBySwitchBlockRPC();
	$getEra->setUrl($Common::ConstValues::MAIN_NET);
	my $bi = new Common::BlockIdentifier();
	
	# Test 1: Call with block hash
	$bi->setBlockType("hash");
	$bi->setBlockHash("f028506fb8add2edd3f9f3713e5acd7441a5d0cd433b863c627ff6542e8c0860");
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	my $getEraResult = $getEra->getEraInfo($postParamStr);
	ok($getEraResult->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $eraSummary = $getEraResult->getEraSummary();
	ok($eraSummary->getBlockHash() eq "f028506fb8add2edd3f9f3713e5acd7441a5d0cd433b863c627ff6542e8c0860","Test 1 block hash value, Passed");
	ok($eraSummary->getEraId() == 2,"Test 1 era id value, Passed");
	ok($eraSummary->getStateRootHash() eq "112bc563aae7ed8a55ff0e7cfc95929ab5b48d69bf11be124542eec40085ae16","Test 1 state root hash value, Passed");
	ok(length($eraSummary->getMerkleProof()) == 26336, "Test 1 Merkle proof value, Passed");
	my $storedValue = $eraSummary->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_ERA_INFO, "Test 1 stored value of type EraInfo, Passed");
	my $eraInfo = $storedValue->getItsValue();
	my @listSA = $eraInfo->getSeigniorageAllocations();
	my $totalSA = @listSA;
	ok($totalSA == 199, "Test 1 total seigniorage_allocation = 199, Passed");
	my $saDelegator = $listSA[0]; 
	ok($saDelegator->getIsValidator() == 0, "Test 1 first seigniorage_allocation of type Delegator, Passed");
	ok($saDelegator->getValidatorPublicKey() eq "01026ca707c348ed8012ac6a1f28db031fadd6eb67203501a353b867a08c8b9a80", "Test 1 first seigniorage_allocation validator_public_key value of Delegator, Passed");
	ok($saDelegator->getDelegatorPublicKey() eq "01128ddb51119f1df535cf3a763996344ab0cc79038faaee0aaaf098a078031ce6", "Test 1 first seigniorage_allocation delegator_public_key value of Delegator, Passed");
	ok($saDelegator->getAmount() eq "87735183835", "Test 1 first seigniorage_allocation amount value of Delegator, Passed");

	my $saValidator = $listSA[6]; 
	ok($saValidator->getIsValidator() == 1, "Test 1 first seigniorage_allocation of type Validator, Passed");
	ok($saValidator->getValidatorPublicKey() eq "01026ca707c348ed8012ac6a1f28db031fadd6eb67203501a353b867a08c8b9a80", "Test 1 first seigniorage_allocation validator_public_key value of Validator, Passed");
	ok($saValidator->getAmount() eq "749985612238", "Test 1 first seigniorage_allocation amount value of Validator, Passed");
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("208");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	$getEraResult = $getEra->getEraInfo($postParamHeightStr);
	ok($getEraResult->getApiVersion() eq "1.4.5", "Test 2 api_version, Passed");
	$eraSummary = $getEraResult->getEraSummary();
	ok($eraSummary->getBlockHash() eq "623199fd62ce81e9870db8b301afcdd2491eae4555396c58825d699c4d58dd62","Test 1 block hash value, Passed");
		
	# Test 3: Call with no parameter, latest block transfer is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	$getEraResult = $getEra->getEraInfo($postParamNoneStr);
	ok($getEraResult->getApiVersion() eq "1.4.5", "Test 3 api_version, Passed");
	$eraSummary = $getEraResult->getEraSummary();
		
	# Negative test: Test 4: Call with wrong block hash, latest block transfer is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	$getEraResult = $getEra->getEraInfo($postParamStr4);
	ok($getEraResult->getApiVersion() eq "1.4.5", "Test 4 api_version, Passed");
	$eraSummary = $getEraResult->getEraSummary();
	
	# Negative test: Test 5: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	my $error = $getEra->getEraInfo($postParamStr5);
	ok($error->getErrorCode() eq "-32001", "Test error get era info with block height > U64.max, error code checked, Passed");
	ok($error->getErrorMessage() eq "block not known", "Test error get era info with block height > U64.max, error is thrown, error message checked, Passed");
	
	# Negative test: Test 6: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("75052400");
	my $postParamStr6 = $bi->generatePostParam($Common::ConstValues::RPC_GET_ERA);
	my $error2 =  $getEra->getEraInfo($postParamStr6);
	ok($error2->getErrorCode() eq "-32001", "Test error get era info with block height > U64.max, error code checked, Passed");
	ok($error2->getErrorMessage() eq "block not known", "Test error get era info with block height > U64.max, error is thrown, error message checked, Passed");
}
getEraInfo();