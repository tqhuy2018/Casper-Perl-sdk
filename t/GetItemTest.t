#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 90;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);
use Common::ConstValues;
use GetItem::GetItemParams;
use GetItem::GetItemResult;
use GetItem::GetItemRPC;
use Common::ConstValues;

# Test 2: Test for StoredValue of type CLValue
sub getItem1 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("340a09b06bae99d868c68111b691c70d9d5a253c0f2fd7ee257a04a198d3818e");
	$getItemParams->setKey("uref-ba620eee2b06c6df4cd8da58dd5c5aa6d42f3a502de61bb06dc70b164eee4119-007");
	my $paramStr = $getItemParams->generateParameterStr();
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 35056, "Test 1, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_CLVALUE, "Test 1, stored value of type CLValue");
	my $clValue = $storedValue->getItsValue();
	ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_ANY, "Test 1, stored value of type CLValue, cltype of type Any, Passed");
	ok($clValue->getBytes() eq "050000006b69747479040000000c0000004f6666696365205370616365010c00000050756c702046696374696f6e011200000054686520426c7565732042726f7468657273000d00000054686520476f6466617468657200", "Test 1, stored value of type CLValue, bytes value, Passed");
	ok($clValue->getParse()->getItsValueStr() eq $Common::ConstValues::NULL_VALUE, "Test 1, parse value NULL, Passed");
}
# Test 2: Test for StoredValue of type Account
sub getItem2 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("b31f42523b6799d6d403a3119596c958abf2cdba31066322f01e5fa38ef999aa");
	$getItemParams->setKey("account-hash-ff2ae80f71c1ffcac4921100a21b67ddecf59a30fb86eb6979f47c8838b3b7d3");
	my $paramStr = $getItemParams->generateParameterStr();
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 2 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 25428, "Test 2, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_ACCOUNT, "Test 2, stored value of type Account");
	my $account = $storedValue->getItsValue();
	ok($account->getAccountHash() eq "account-hash-ff2ae80f71c1ffcac4921100a21b67ddecf59a30fb86eb6979f47c8838b3b7d3", "Test 2, account hash, Passed");
	my @namedKeys = $account->getNamedKeys();
	my $totalNamedKey = @namedKeys;
	ok($totalNamedKey == 0, "Test 2, total NamedKey = 0, Passed");
	ok($account->getMainPurse() eq "uref-cd58e9c4a8d1caaba3a3fc030a112a8b4bd904fd83b806bf575c25751e20ee22-007", "Test 2, main purse, Passed");
	my @aKeys = $account->getAssociatedKeys();
	my $totalKey = @aKeys;
	ok($totalKey == 1, "Test 2, total AssociatedKeys = 1, Passed");
	my $oneKey = $aKeys[0];
	ok($oneKey->getAccountHash() eq "account-hash-ff2ae80f71c1ffcac4921100a21b67ddecf59a30fb86eb6979f47c8838b3b7d3", "Test 2, first AssociatedKey account hash, Passed" );
	ok($oneKey->getWeight() == 1, "Test 2, first AssociatedKey weight value, Passed");
	my @at = $account->getActionThresholds();
	my $totalAT = @at;
	ok($totalAT == 1, "Test 2, total ActionThreshold = 1, Passed");
	my $oneAT = $at[0];
	ok($oneAT->getDeployment() == 1, "Test 2, first ActionThreshold development = 1, Passed "); 
	ok($oneAT->getKeyManagement() == 1, "Test 2, first ActionThreshold KeyManagement = 1, Passed "); 
}


# Test 3: Test for StoredValue of type Transfer
sub getItem3 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("1416302b2c637647e2fe8c0b9f7ee815582cc7a323af5823313ff8a8684c8cf8");
	$getItemParams->setKey("transfer-8218fa8c55c19264e977bf2bae9f5889082aee4d2c4eaf9642478173c37d1ed4");
	my $paramStr = $getItemParams->generateParameterStr();
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 3 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 41424, "Test 3, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_TRANSFER, "Test 3, stored value of type Transfer");
	my $transfer = $storedValue->getItsValue();
	ok($transfer->getDeployHash() eq "e96e884ea0d816d478e965a655e0280d69353b7e231180c34453407a6055646d", "Test 3, transfer deploy hash, Passed");
	ok($transfer->getFrom() eq "account-hash-516bae78a83f7b0f6a34a256507434e0f1a432cb0bb2212ca54a01d9ca5a15c9", "Test 3, transfer from, Passed");
	ok($transfer->getTo() eq "account-hash-45f3aa6ce2a450dd5a4f2cc4cc9054aded66de6b6cfc4ad977e7251cf94b649b", "Test 3, transfer to, Passed");
	ok($transfer->getSource() eq "uref-138ed0de11e2837215e06af87c579bc389459f885be8e124fde4c317df2891d7-007", "Test 3, transfer source, Passed");
	ok($transfer->getTarget() eq "uref-c874cfe0c930bb6d44bce16417a78aecf02f87c8890149f91d6b5802152a1dd6-004", "Test 3, transfer target, Passed");
	ok($transfer->getAmount() eq "2500000000", "Test 3, transfer amount, Passed");
	ok($transfer->getGas() == 0 , "Test 3, transfer gas, Passed");
	ok($transfer->getId() == 0 , "Test 3, transfer id, Passed");
}
# Test 4: Test for StoredValue of type DeployInfo
sub getItem4 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("1416302b2c637647e2fe8c0b9f7ee815582cc7a323af5823313ff8a8684c8cf8");
	$getItemParams->setKey("deploy-a49c06f9b2adf02812a7b2fdcad08804a2ce4896ffec7c06c920d417e7e39cfe");
	my $paramStr = $getItemParams->generateParameterStr();
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 4 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 39984, "Test 4, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_DEPLOY_INFO, "Test 4, stored value of type DeployInfo");
	my $deployInfo = $storedValue->getItsValue();
	ok($deployInfo->getDeployHash() eq "a49c06f9b2adf02812a7b2fdcad08804a2ce4896ffec7c06c920d417e7e39cfe", "Test 4, DeployInfo - deploy hash, Passed");
	ok($deployInfo->getFrom() eq "account-hash-516bae78a83f7b0f6a34a256507434e0f1a432cb0bb2212ca54a01d9ca5a15c9", "Test 4, DeployInfo - from, Passed");
	ok($deployInfo->getSource() eq "uref-138ed0de11e2837215e06af87c579bc389459f885be8e124fde4c317df2891d7-007", "Test 4, DeployInfo - source, Passed");
	ok($deployInfo->getGas() eq "100000000", "Test 4, DeployInfo - gas, Passed");
	my @transfers = $deployInfo->getTransfers();
	my $totalTransfer = @transfers;
	ok($totalTransfer == 1, "Test 4, total transfer = 1, Passed");
	my $firstTransfer = $transfers[0];
	ok($firstTransfer eq "transfer-c749305c07f8de0aa1898929db4a93b3b136e408707878ae15155910d840b4c7", "Test 4, first transfer value, Passed");
}
# Test 5: Test for StoredValue of type Bid
sub getItem5 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("647C28545316E913969B032Cf506d5D242e0F857061E70Fb3DF55980611ace86");
	$getItemParams->setKey("bid-24b6D5Aabb8F0AC17D272763A405E9CECa9166B75B745Cf200695E172857c2dD");
	my $paramStr = $getItemParams->generateParameterStr();
	$getItemRPC->setUrl($Common::ConstValues::MAIN_NET);
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 5 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 905760, "Test 5, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_BID, "Test 5, stored value of type Bid, Passed");
	my $bid = $storedValue->getItsValue();
	ok($bid->getBondingPurse() eq "uref-9ef6b11bd095c1733956e3b7e5bb47630f5fa59ad9a89c87fa671a1177e0c025-007", "Test 5, bid - bonding purse , Passed");
	ok($bid->getDelegationRate() eq "10", "Test 5, bid - delegation rate , Passed");
	ok($bid->getInactive() == 0, "Test 5, bid - inactive , Passed");
	ok($bid->getStakedAmount() eq "208330980103513", "Test 5, bid - staked_amount , Passed");
	ok($bid->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b", "Test 5, bid - validator_public_key , Passed");
	# test VestingSchedule
	my $vs = $bid->getVestingSchedule();
	ok ($vs->getInitialReleaseTimestampMillis() eq "1624978800000", "Test 5, vesting_schedule - initial_release_timestamp_millis, Passed");
	my @lockAmounts = $vs->getLockedAmounts();
	my $totalLA =  @lockAmounts;
	ok($totalLA == 14, "Test 5, total locked_amount = 14, Passed");
	ok($lockAmounts[0] eq "1359796682549793", "Test 5, 1st locked_amount value, Passed");
	ok($lockAmounts[1] eq "1255196937738271", "Test 5, 2nd locked_amount value, Passed");
	ok($lockAmounts[2] eq "1150597192926749", "Test 5, 3rd locked_amount value, Passed");
	ok($lockAmounts[3] eq "1045997448115227", "Test 5, 4th locked_amount value, Passed");
	ok($lockAmounts[4] eq "941397703303705", "Test 5, 5th locked_amount value, Passed");
	ok($lockAmounts[5] eq "836797958492183", "Test 5, 6th locked_amount value, Passed");
	ok($lockAmounts[13] eq "0", "Test 5, 14th locked_amount value, Passed");
	# test delegators
	my @delegators = $bid->getDelegators();
	my $totalD = @delegators;
	ok($totalD == 3186, "Test 5, total Delegator = 3186, Passed");
	# test first delegator values
	my $firstD = $delegators[0];
	ok($firstD->getPublicKey() eq "0100716b994e9264452111d2c9cdca048137906c22976129b93e0f1539ad4df449","Test 5, delegator public key, Passed");
	ok($firstD->getBondingPurse() eq "uref-1b52cdf087eb535471e0507269cb14be2abeb7427e102acb18b35cfb5df9a273-007","Test 5, delegator bonding purse, Passed");
	ok($firstD->getStakedAmount() eq "11906543547306","Test 5, delegator stake amount, Passed");
	ok($firstD->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b","Test 5, delegator validator_public_key, Passed");
	ok($firstD->getDelegatorPublicKey() eq "0100716b994e9264452111d2c9cdca048137906c22976129b93e0f1539ad4df449","Test 5, delegator delegator_public_key, Passed");
	ok($firstD->getIsVSExists() == 0, "Test 5, VestingSchedule does not exist, Passed");
	# assertion for delegator with existing vestingSchedule, get the 42nd delegator in the list to check
	my $d41 = $delegators[41];
	ok($d41->getPublicKey() eq "01045ac0fd84e85c852526fa58447fd36c1054cc67cde05992acf65411bb568d01","Test 5, delegator public key, Passed");
	ok($d41->getBondingPurse() eq "uref-8f50ea318c811305439693990329c94d5a16214ea636e73167cb39d7630edcb7-007","Test 5, delegator bonding purse, Passed");
	ok($d41->getStakedAmount() eq "133997464806886","Test 5, delegator stake amount, Passed");
	ok($d41->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b","Test 5, delegator validator_public_key, Passed");
	ok($d41->getDelegatorPublicKey() eq "01045ac0fd84e85c852526fa58447fd36c1054cc67cde05992acf65411bb568d01","Test 5, delegator delegator_public_key, Passed");
	ok($d41->getIsVSExists() == 1, "Test 5, 42nd Delegator, VestingSchedule does exist, Passed");
	my $vs2 = $d41->getVestingSchedule();
	ok ($vs2->getInitialReleaseTimestampMillis() eq "1624978800000", "Test 5, 42nd Delegator - vesting_schedule - initial_release_timestamp_millis, Passed");
	my @lockAmounts2 = $vs2->getLockedAmounts();
	my $totalLA2 =  @lockAmounts2;
	ok($totalLA2 == 14, "Test 5, total locked_amount = 14, Passed");
	ok($lockAmounts2[0] eq "33805201971412311", "Test 5, 1st locked_amount value, Passed");
	ok($lockAmounts2[1] eq "31204801819765211", "Test 5, 2nd locked_amount value, Passed");
	ok($lockAmounts2[13] eq "0", "Test 5, 14th locked_amount value, Passed");
	
}

# Test 6: Test for StoredValue of type Withdraw
sub getItem6 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228");
	$getItemParams->setKey("withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1");
	my $paramStr = $getItemParams->generateParameterStr();
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 6 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 6876, "Test 6, merkle proof, Passed");
	my $storedValue = $getItemResult->getStoredValue();
	ok($storedValue->getItsType() eq $Common::ConstValues::STORED_VALUE_WITHDRAW, "Test 6, stored value of type Withdraw");
	my $withdraw = $storedValue->getItsValue();
	my @listUP = $withdraw->getListUnbondingPurse();
	my $totalUP = @listUP;
	ok($totalUP == 1, "Test total UnbondingPurse =1 , Passed");
	my $oneUP = $listUP[0];
	ok($oneUP->getBondingPurse() eq "uref-5fcc3031ea2572f9929e0cfcfc84c6c3131bfe1e78bce8cb61f99f59eace7795-007", "Test 6, UnbondingPurse - bondingPurse, Passed");
	ok($oneUP->getValidatorPublicKey() eq "01d949a3a1963db686607a00862f79b76ceb185fc134d0aeedb686f1c151f4ae54", "Test 6, UnbondingPurse - validatorPublicKey, Passed");
	ok($oneUP->getAmount() eq "500", "Test 6, UnbondingPurse - amount, Passed");
	ok($oneUP->getUnbonderPublicKey() eq "01d949a3a1963db686607a00862f79b76ceb185fc134d0aeedb686f1c151f4ae54", "Test 6, UnbondingPurse - unbonderPublicKey, Passed");
	ok($oneUP->getEraOfCreation() eq "3319", "Test 6, UnbondingPurse - eraOfCreation, Passed");
}

# Negative test: Test 7: Sending wrong state root hash
sub getItem7 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("AAA");
	$getItemParams->setKey("withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1");
	my $paramStr = $getItemParams->generateParameterStr();
	my $error2 = $getItemRPC->getItem($paramStr);
	ok($error2->getErrorCode() eq "-32602", "Test error get item with wrong state root hash, error code checked, Passed");
	ok($error2->getErrorMessage() eq "Invalid params", "Test error get item with wrong state root hash, error is thrown, error message checked, Passed");
}
# Negative test: Test 8: Sending wrong key
sub getItem8 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228");
	$getItemParams->setKey("withdraw-AAA");
	my $paramStr = $getItemParams->generateParameterStr();
	my $error2 = $getItemRPC->getItem($paramStr);
	ok($error2->getErrorCode() eq "-32002", "Test error get item with wrong key, error code checked, Passed");
	ok($error2->getErrorMessage() eq "failed to parse key: withdraw-key from string error: Base16 data cannot have length 3 (must be even)", "Test error get item with wrong key, error is thrown, error message checked, Passed");
}
# Negative test: Test 9: Sending wrong key and state root hash
sub getItem9 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("BBB");
	$getItemParams->setKey("withdraw-AAA");
	my $paramStr = $getItemParams->generateParameterStr();
	my $error2 = $getItemRPC->getItem($paramStr);
	ok($error2->getErrorCode() eq "-32602", "Test error get item with wrong state root hash, error code checked, Passed");
	ok($error2->getErrorMessage() eq "Invalid params", "Test error get item with wrong state root hash, error is thrown, error message checked, Passed");
}
# Negative test: Test 10: Sending wrong path
sub getItem10 {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	$getItemParams->setStateRootHash("d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228");
	$getItemParams->setKey("withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1");
	my @path = ("path1","path2","path3");
	$getItemParams->setPath(@path);
	my $paramStr = $getItemParams->generateParameterStr();
	my $error2 = $getItemRPC->getItem($paramStr);
	ok($error2->getErrorCode() eq "-32003", "Test error get item with wrong state root hash, error code checked, Passed");
	ok($error2->getErrorMessage() eq "state query failed: ValueNotFound(\"UnbondingPurses value found. at path: Key::Withdraw(df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1)\")", "Test error get item with wrong state root hash, error is thrown, error message checked, Passed");
}
getItem1();
getItem2();
getItem3();
getItem4();
getItem5();
getItem6();
getItem7();
getItem8();
getItem9();
getItem10();
