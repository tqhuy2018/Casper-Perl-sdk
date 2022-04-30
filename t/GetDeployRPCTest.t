#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 100;

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use GetDeploy::GetDeployRPC;
use GetDeploy::GetDeployParams;

#Test 1: information for deploy at this address: https://testnet.cspr.live/deploy/55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa
sub getDeploy1 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	my $deployPayment = $deploy->getPayment();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "01a080d935c4c9415b3d296f7570d99a49e10da8dc293c7ec3a6a3d8758f2e128c","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "dfa3a2b76fdbe1e2fd8fc37e2feaabb4d0a5392e9b82a68372f2921c899326bb","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-04-27T08:23:59.420Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "30m","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa","Test deploy hash - Passed");
	
	# Test assertion for Deploy payment
	
	my $payment = $deploy->getPayment();
	ok($payment->getItsType() eq "ModuleBytes","Test deploy payment of type ModuleBytes - Passed");
	my $paymentValue = $payment->getItsValue();
	ok($paymentValue->getModuleBytes() eq "","Test deploy payment module_bytes - Passed");
	my $paymentArgs = $paymentValue->getArgs();
	my @listArgs = @{$paymentArgs->getListNamedArg()};
	my $totalArgs = @listArgs;
	#Test for first args
	my $counter1 = 0;
	my $oneNA;
	foreach(@listArgs) {
		if($counter1 == 2) {
			$oneNA = $_;
		}
		$counter1 ++;
	}
	# The real args list contains 1 element, but the list in Perl hold 1 + 2 = 3 elements with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgs - 2 == 1, "Test payment total args = 1 - Passed");
	ok($oneNA->getItsName() eq "amount", "Test payment first arg name = amount - Passed");
	my $paymentFirstArgCLValue = $oneNA->getCLValue();
	ok($paymentFirstArgCLValue->getBytes() eq "0500c817a804","Test payment first arg CLValue, bytes value = 0500c817a804 - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "20000000000","Test payment first arg CLValue, parse = 20000000000 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	print "total session args".$totalArgsSession."\n";
	# The real args list contains 9 element, but the list in Perl hold 9 + 2 = 11 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 9, "Test session total args = 9 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 10) {
			$oneNASession = $_;
		} elsif($counter1 == 2) {
			$oneNASession2 = $_;
		}
		$counter1 ++;
	}
	# Assertion for 9th Arg
	ok($oneNASession->getItsName() eq "pair", "Test session 9th arg name = pair - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b","Test session 9th arg CLValue, bytes value = 0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 9th arg CLValue, cl_type = Option - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Key","Test session 9th arg CLValue, cl_type = Option(Key) Passed");
	ok($sessionArgCLValue->getParse()->getItsValueStr() eq "hash-562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b","Test payment first arg CLValue, parse = hash-562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b - Passed");
	# Assertion for first Arg
	ok($oneNASession2->getItsName() eq "token_a", "Test session first arg name = token_a - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test session first arg CLValue, bytes value = 01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "Key","Test session first arg CLValue, cl_type = Key - Passed");
	ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test payment first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
}

#Test 2: information for deploy at this address: https://testnet.cspr.live/deploy/AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268
# Test the following CLType: List(U256), List(Map(String,String))) 
sub getDeploy2 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	my $deployPayment = $deploy->getPayment();
	print "deploy 2 header account:".$deploy->getHeader()->getAccount()."\n";
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "016d9e3db0a800aef8d18975b469c77bef042ee909d24cb83d27df97a22bb6d8ad","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "c406b290036fde575a70505da636b412ee36bb10ee449d3c5eb5276c4e3c08a8","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-02T20:51:59.076Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "5h","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "aab4aa0c14a37bc9386020609aa1cabad895c3e2e104d877b936c6ffa2302268","Test deploy hash - Passed");
	
	# Test assertion for Deploy payment
	
	my $payment = $deploy->getPayment();
	ok($payment->getItsType() eq "ModuleBytes","Test deploy payment of type ModuleBytes - Passed");
	my $paymentValue = $payment->getItsValue();
	ok($paymentValue->getModuleBytes() eq "","Test deploy payment module_bytes - Passed");
	my $paymentArgs = $paymentValue->getArgs();
	my @listArgs = @{$paymentArgs->getListNamedArg()};
	my $totalArgs = @listArgs;
	#Test for first args
	my $counter1 = 0;
	my $oneNA;
	foreach(@listArgs) {
		if($counter1 == 2) {
			$oneNA = $_;
		}
		$counter1 ++;
	}
	# The real args list contains 1 element, but the list in Perl hold 1 + 2 = 3 elements with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgs - 2 == 1, "Test payment total args = 1 - Passed");
	ok($oneNA->getItsName() eq "amount", "Test payment first arg name = amount - Passed");
	my $paymentFirstArgCLValue = $oneNA->getCLValue();
	ok($paymentFirstArgCLValue->getBytes() eq "04a07be02b","Test payment first arg CLValue, bytes value = 04A07be02b - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "736132000","Test payment first arg CLValue, parse = 736132000 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 3 element, but the list in Perl hold 3 + 2 = 5 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 3, "Test session total args = 3 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession1;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 2) {
			$oneNASession = $_;
		} elsif($counter1 == 3) {
			$oneNASession1 = $_;
		}  elsif($counter1 == 4) {
			$oneNASession2 = $_;
		}
		$counter1 ++;
	}
	# Assertion for first Arg
	ok($oneNASession->getItsName() eq "recipient", "Test session first arg name = recipient - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "00d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test session first arg CLValue, bytes value = 00d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Key","Test session first arg CLValue, cl_type = Key - Passed");
	ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	# Assertion for second Arg
	ok($oneNASession1->getItsName() eq "token_ids", "Test session second arg name = recipient - Passed");
	my $sessionArgCLValue1 = $oneNASession1->getCLValue();
	ok($sessionArgCLValue1->getBytes() eq "010000000102","Test session second arg CLValue, bytes value = 010000000102 - Passed");
	ok($sessionArgCLValue1->getCLType()->getItsTypeStr() eq "List","Test session second arg CLValue, cl_type = List - Passed");
	
	ok($sessionArgCLValue1->getCLType()->getInnerCLType1()->getItsTypeStr() eq "U256","Test session 3rd arg CLValue, cl_type = List(U256)- Passed");
	my @listCLParse = $sessionArgCLValue1->getParse()->getItsValueList();
	my $listLength = @listCLParse;
	# assertion that the parse for clvalue of 3rd arg is a list and the list is of 2 elements
	ok($listLength == 1,"Test session second arg CLValue, parse is a list of 1 elements- Passed");
	$counter1 = 0;
	foreach(@listCLParse) {
		if($counter1 == 0) {
			my $parseValue = $_;
			print "value is --: ".$parseValue->getItsValueStr()."\n";
			ok($parseValue->getItsValueStr() eq "2","Test session second arg CLValue, parse only element value is 2- Passed");
		} 
		$counter1 ++;
	}
	
	# Assertion for third Arg
	ok($oneNASession2->getItsName() eq "token_metas", "Test session third arg name = token_metas - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b","Test session third arg CLValue, bytes value = 010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "List","Test session third arg CLValue, cl_type = List - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Map","Test session third arg CLValue, cl_type = List(Map) - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType1()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String) type String for map->key - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType2()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String) type String for map->value - Passed");	
	#ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test payment first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
}

# Test 3: information for deploy at this address: https://testnet.cspr.live/deploy/430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e
# Test the following CLType: U64, List(String), ByteArray
sub getDeploy3 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	my $deployPayment = $deploy->getPayment();
	print "deploy 2 header account:".$deploy->getHeader()->getAccount()."\n";
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "0203d9f3588e6589f334938f88ce50b2d6e15d90e2979d9cb533bf44772581f06e01","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "73b9bd80c07eddf12dfdf1b2db4cf3ae803728e631030d0405853b471249891c","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-14T00:20:27.319Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "5h","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e","Test deploy hash - Passed");
	
	# Test assertion for Deploy payment
	
	my $payment = $deploy->getPayment();
	ok($payment->getItsType() eq "ModuleBytes","Test deploy payment of type ModuleBytes - Passed");
	my $paymentValue = $payment->getItsValue();
	ok($paymentValue->getModuleBytes() eq "","Test deploy payment module_bytes - Passed");
	my $paymentArgs = $paymentValue->getArgs();
	my @listArgs = @{$paymentArgs->getListNamedArg()};
	my $totalArgs = @listArgs;
	#Test for first args
	my $counter1 = 0;
	my $oneNA;
	foreach(@listArgs) {
		if($counter1 == 2) {
			$oneNA = $_;
		}
		$counter1 ++;
	}
	# The real args list contains 1 element, but the list in Perl hold 1 + 2 = 3 elements with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgs - 2 == 1, "Test payment total args = 1 - Passed");
	ok($oneNA->getItsName() eq "amount", "Test payment first arg name = amount - Passed");
	my $paymentFirstArgCLValue = $oneNA->getCLValue();
	ok($paymentFirstArgCLValue->getBytes() eq "0500eaa55a01","Test payment first arg CLValue, bytes value = 0500eaa55a01 - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "5815790080","Test payment first arg CLValue, parse = 5815790080 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 3 element, but the list in Perl hold 3 + 2 = 5 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 8, "Test session total args = 3 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession1;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 4) {
			$oneNASession = $_;
		} elsif($counter1 == 6) {
			$oneNASession1 = $_;
		}  elsif($counter1 == 8) {
			$oneNASession2 = $_;
		}
		$counter1 ++;
	}
	# Assertion for first Arg
	ok($oneNASession->getItsName() eq "path", "Test session 3rd arg name = path - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "0200000045000000686173682d3942323837663335623743313136353930343663463537354231333035354464453746394133303963616535464531634533636139383564383766303239623045000000686173682d43383932393034353233333230443962366665343041363135433630653446316363373165333335313531373362466366356536363030304430393736433430","Test session first arg CLValue, bytes value = 0200000045000000686173682d3942323837663335623743313136353930343663463537354231333035354464453746394133303963616535464531634533636139383564383766303239623045000000686173682d43383932393034353233333230443962366665343041363135433630653446316363373165333335313531373362466366356536363030304430393736433430 - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "List","Test session 3rd arg CLValue, cl_type = List - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "String","Test session 3rd arg CLValue, cl_type = List(String)- Passed");
	my @listCLParse = $sessionArgCLValue->getParse()->getItsValueList();
	my $listLength = @listCLParse;
	# assertion that the parse for clvalue of 3rd arg is a list and the list is of 2 elements
	ok($listLength == 2,"Test session 3rd arg CLValue, parse is a list of 2 elements- Passed");
	$counter1 = 0;
	foreach(@listCLParse) {
		if($counter1 == 0) {
			my $parseValue = $_;
			print "value is --: ".$parseValue->getItsValueStr()."\n";
			ok($parseValue->getItsValueStr() eq "hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0","Test session 3rd arg CLValue, parse first element value is hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0- Passed");
		} elsif($counter1 == 1) {
			my $parseValue = $_;
			print "value is --: ".$parseValue->getItsValueStr()."\n";
			ok($parseValue->getItsValueStr() eq "hash-C892904523320D9b6fe40A615C60e4F1cc71e33515173bFcf5e66000D0976C40","Test session 3rd arg CLValue, parse second element value is hash-C892904523320D9b6fe40A615C60e4F1cc71e33515173bFcf5e66000D0976C40- Passed");
		}
		$counter1 ++;
	}
	#ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	# Assertion for second Arg
	ok($oneNASession1->getItsName() eq "deadline", "Test session 5th arg name = deadline - Passed");
	my $sessionArgCLValue1 = $oneNASession1->getCLValue();
	ok($sessionArgCLValue1->getBytes() eq "b75107567e010000","Test session 5th arg CLValue, bytes value = b75107567e010000 - Passed");
	ok($sessionArgCLValue1->getCLType()->getItsTypeStr() eq "U64","Test session 5th arg CLValue, cl_type = U64 - Passed");
	#ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269 - Passed");
	# Assertion for third Arg
	ok($oneNASession2->getItsName() eq "target", "Test session 7th arg name = target - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f","Test session 7th arg CLValue, bytes value = 4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "ByteArray","Test session 7th arg CLValue, cl_type = ByteArray - Passed");
	#ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test payment first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
}

# Test 4: information for deploy at this address: https://testnet.cspr.live/deploy/a91d468e2ddc8936f7866bc594794b322f747508c2192fd4eca90ef8a121d45e
# Test the following CLType: Option(List(String)), List(Map(String,String)) with value and with no value
sub getDeploy4 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("a91d468e2ddc8936f7866bc594794b322f747508c2192fd4eca90ef8a121d45e");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	my $deployPayment = $deploy->getPayment();
	print "deploy 2 header account:".$deploy->getHeader()->getAccount()."\n";
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "0203d9f3588e6589f334938f88ce50b2d6e15d90e2979d9cb533bf44772581f06e01","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "73b9bd80c07eddf12dfdf1b2db4cf3ae803728e631030d0405853b471249891c","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-14T00:20:27.319Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "5h","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e","Test deploy hash - Passed");
	
	# Test assertion for Deploy payment
	
	my $payment = $deploy->getPayment();
	ok($payment->getItsType() eq "ModuleBytes","Test deploy payment of type ModuleBytes - Passed");
	my $paymentValue = $payment->getItsValue();
	ok($paymentValue->getModuleBytes() eq "","Test deploy payment module_bytes - Passed");
	my $paymentArgs = $paymentValue->getArgs();
	my @listArgs = @{$paymentArgs->getListNamedArg()};
	my $totalArgs = @listArgs;
	#Test for first args
	my $counter1 = 0;
	my $oneNA;
	foreach(@listArgs) {
		if($counter1 == 2) {
			$oneNA = $_;
		}
		$counter1 ++;
	}
	# The real args list contains 1 element, but the list in Perl hold 1 + 2 = 3 elements with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgs - 2 == 1, "Test payment total args = 1 - Passed");
	ok($oneNA->getItsName() eq "amount", "Test payment first arg name = amount - Passed");
	my $paymentFirstArgCLValue = $oneNA->getCLValue();
	ok($paymentFirstArgCLValue->getBytes() eq "0500eaa55a01","Test payment first arg CLValue, bytes value = 0500eaa55a01 - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "5815790080","Test payment first arg CLValue, parse = 5815790080 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 3 element, but the list in Perl hold 3 + 2 = 5 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 8, "Test session total args = 3 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession1;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 4) {
			$oneNASession = $_;
		} elsif($counter1 == 6) {
			$oneNASession1 = $_;
		}  elsif($counter1 == 8) {
			$oneNASession2 = $_;
		}
		$counter1 ++;
	}
	# Assertion for first Arg
	ok($oneNASession->getItsName() eq "path", "Test session 3rd arg name = path - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "0200000045000000686173682d3942323837663335623743313136353930343663463537354231333035354464453746394133303963616535464531634533636139383564383766303239623045000000686173682d43383932393034353233333230443962366665343041363135433630653446316363373165333335313531373362466366356536363030304430393736433430","Test session first arg CLValue, bytes value = 0200000045000000686173682d3942323837663335623743313136353930343663463537354231333035354464453746394133303963616535464531634533636139383564383766303239623045000000686173682d43383932393034353233333230443962366665343041363135433630653446316363373165333335313531373362466366356536363030304430393736433430 - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "List","Test session 3rd arg CLValue, cl_type = List - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "String","Test session 3rd arg CLValue, cl_type = List(String)- Passed");
	my @listCLParse = $sessionArgCLValue->getParse()->getItsValueList();
	my $listLength = @listCLParse;
	# assertion that the parse for clvalue of 3rd arg is a list and the list is of 2 elements
	ok($listLength == 2,"Test session 3rd arg CLValue, parse is a list of 2 elements- Passed");
	$counter1 = 0;
	foreach(@listCLParse) {
		if($counter1 == 0) {
			my $parseValue = $_;
			print "value is --: ".$parseValue->getItsValueStr()."\n";
			ok($parseValue->getItsValueStr() eq "hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0","Test session 3rd arg CLValue, parse first element value is hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0- Passed");
		} elsif($counter1 == 1) {
			my $parseValue = $_;
			print "value is --: ".$parseValue->getItsValueStr()."\n";
			ok($parseValue->getItsValueStr() eq "hash-C892904523320D9b6fe40A615C60e4F1cc71e33515173bFcf5e66000D0976C40","Test session 3rd arg CLValue, parse second element value is hash-C892904523320D9b6fe40A615C60e4F1cc71e33515173bFcf5e66000D0976C40- Passed");
		}
		$counter1 ++;
	}
	#ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	# Assertion for second Arg
	ok($oneNASession1->getItsName() eq "deadline", "Test session 5th arg name = deadline - Passed");
	my $sessionArgCLValue1 = $oneNASession1->getCLValue();
	ok($sessionArgCLValue1->getBytes() eq "b75107567e010000","Test session 5th arg CLValue, bytes value = b75107567e010000 - Passed");
	ok($sessionArgCLValue1->getCLType()->getItsTypeStr() eq "U64","Test session 5th arg CLValue, cl_type = U64 - Passed");
	#ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9cA1353597c4004B8F881b397a89c1779004F5E547e04b57c2e7967c6269 - Passed");
	# Assertion for third Arg
	ok($oneNASession2->getItsName() eq "target", "Test session 7th arg name = target - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f","Test session 7th arg CLValue, bytes value = 4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "ByteArray","Test session 7th arg CLValue, cl_type = ByteArray - Passed");
	#ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test payment first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
}
getDeploy1();
getDeploy2();
getDeploy3();
