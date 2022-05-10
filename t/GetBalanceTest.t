#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 15;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

use Common::ConstValues;
use GetBalance::GetBalanceParams;
use GetBalance::GetBalanceResult;
use GetBalance::GetBalanceResultRPC;
use Common::ConstValues;
# Positive test 1
sub getBalance1 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189");
	$params->setPurseUref("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
	my $paramStr = $params->generateParameterStr();
	my $result = $rpc->getBalance($paramStr);
	ok($result->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok(length($result->getMerkleProof()) == 31766, "Test 1, merkle proof, Passed");
	ok($result->getBalanceValue() eq "522693296224", "Test 1, balanceValue, Passed");
}
# Positive test 2
sub getBalance2 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("f60f4b3b69584cfa56a10e3d8882d9d81b5859cea3695dbdfb2198b05a71a00b");
	$params->setPurseUref("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
	my $paramStr = $params->generateParameterStr();
	my $result = $rpc->getBalance($paramStr);
	ok($result->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok(length($result->getMerkleProof()) == 32650, "Test 2, merkle proof, Passed");
	ok($result->getBalanceValue() eq "345375534574", "Test 2, balanceValue, Passed");
}
# Positive test 3
sub getBalance3 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("aae5a164f4d80c15b36dd82d0512013c525f4c8ce5833405b44a5094496610cf");
	$params->setPurseUref("uref-1303d3004197c2511da8d172479c00c13e95b400bb29cda5c4a0a05e74d38bb8-004");
	my $paramStr = $params->generateParameterStr();
	my $result = $rpc->getBalance($paramStr);
	ok($result->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok(length($result->getMerkleProof()) == 32584, "Test 3, merkle proof, Passed");
	ok($result->getBalanceValue() eq "9354495182020", "Test 3, balanceValue, Passed");
}

# Negative test 1: send the wrong state root hash
sub getBalance4 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("AAA"); # THIS IS WRONG VALUE
	$params->setPurseUref("uref-1303d3004197c2511da8d172479c00c13e95b400bb29cda5c4a0a05e74d38bb8-004");
	my $paramStr = $params->generateParameterStr();
	my $error = $rpc->getBalance($paramStr);
	ok($error->getErrorCode() eq "-32602", "Test error get balance with wrong state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "Invalid params", "Test error get balance with wrong state root hash, error is thrown, error message checked, Passed");	
}
# Negative test 2: send the wrong purse uref
sub getBalance5 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("aae5a164f4d80c15b36dd82d0512013c525f4c8ce5833405b44a5094496610cf");
	$params->setPurseUref("uref-AAA1303d3004197c2511da8d172479c00c13e95b400bb29cda5c4a0a05e74d38bb8-004");  # THIS IS WRONG VALUE
	my $paramStr = $params->generateParameterStr();
	my $error = $rpc->getBalance($paramStr);
	ok($error->getErrorCode() eq "-32005", "Test error get balance with purse uref, error code checked, Passed");
	ok($error->getErrorMessage() eq "failed to parse purse_uref: Hex(InvalidLength { length: 67 })", "Test error get balance with wrong purse uref, error is thrown, error message checked, Passed");
}

# Negative test 3: send the wrong purse uref and state root hash
sub getBalance6 {
	my $rpc = new GetBalance::GetBalanceResultRPC();
	my $params = new GetBalance::GetBalanceParams();
	$params->setStateRootHash("AAA"); # THIS IS WRONG VALUE
	$params->setPurseUref("uref-AAA1303d3004197c2511da8d172479c00c13e95b400bb29cda5c4a0a05e74d38bb8-004");  # THIS IS WRONG VALUE
	my $paramStr = $params->generateParameterStr();
	my $error = $rpc->getBalance($paramStr);
	ok($error->getErrorCode() eq "-32602", "Test error get balance with purse uref and state root hash, error code checked, Passed");
	ok($error->getErrorMessage() eq "Invalid params", "Test error get balance with wrong purse uref and state root hash, error is thrown, error message checked, Passed");
}
getBalance1();
getBalance2();
getBalance3();
getBalance4();
getBalance5();
getBalance6();