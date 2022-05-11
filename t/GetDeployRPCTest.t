#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 363;

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use GetDeploy::GetDeployRPC;
use GetDeploy::GetDeployParams;
use Common::ConstValues;

# Test 1: information for deploy at this address: https://testnet.cspr.live/deploy/55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa
# Test the following CLType: U512, U256, Key, Option(Key)
sub getDeploy1 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeployResult($paramStr)->getDeploy();
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
	ok($sessionValue->getItsHash() eq "43165487cb23a771ea6690326da0db3b1781aa40ff33b465951cf30333aa2d49", "Test deploy session of type StoredContractByHash with hash 43165487cb23a771ea6690326da0db3b1781aa40ff33b465951cf30333aa2d49- Passed");
	ok($sessionValue->getEntryPoint() eq "add_liquidity_js_client", "Test deploy session of type StoredContractByHash with entry_point: add_liquidity_js_client- Passed");
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 9 element, but the list in Perl hold 9 + 2 = 11 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 9, "Test session total args = 9 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession1;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 10) { # get CLValue of type Option(Key)
			$oneNASession = $_;
		} elsif($counter1 == 2) { # get CLValue of type Key
			$oneNASession2 = $_;
		} elsif($counter1 == 4) { # get CLValue of type U256
			$oneNASession1 = $_;
		}
		$counter1 ++;
	}
	# Assertion for 9th Arg - CLType of type Option(Key)
	ok($oneNASession->getItsName() eq "pair", "Test session 9th arg name = pair - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b","Test session 9th arg CLValue, bytes value = 0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 9th arg CLValue, cl_type = Option - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Key","Test session 9th arg CLValue, cl_type = Option(Key) Passed");
	ok($sessionArgCLValue->getParse()->getItsValueStr() eq "hash-562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b","Test session 9th arg CLValue, parse = hash-562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b - Passed");
	# Assertion for first Arg - CLType of type Key
	ok($oneNASession2->getItsName() eq "token_a", "Test session first arg name = token_a - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test session first arg CLValue, bytes value = 01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "Key","Test session first arg CLValue, cl_type = Key - Passed");
	ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test session first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
# Assertion for 3rd Arg - - CLType of type U256
	ok($oneNASession1->getItsName() eq "amount_a_desired", "Test session 3rd arg name = token_a - Passed");
	my $sessionArgCLValue1 = $oneNASession1->getCLValue();
	ok($sessionArgCLValue1->getBytes() eq "0400ca9a3b","Test session 3rd arg CLValue, bytes value = 0400ca9a3b - Passed");
	ok($sessionArgCLValue1->getCLType()->getItsTypeStr() eq "U256","Test session 3rd arg CLValue, cl_type = U256 - Passed");
	ok($sessionArgCLValue1->getParse()->getItsValueStr() eq "1000000000","Test session 3rd arg CLValue, parse = 1000000000 - Passed");
}

#Test 2: information for deploy at this address: https://testnet.cspr.live/deploy/AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268
# Test the following CLType: List(U256), List(Map(String,String))) 
sub getDeploy2 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("AaB4aa0C14a37Bc9386020609aa1CabaD895c3E2E104d877B936C6Ffa2302268");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeployResult($paramStr)->getDeploy();
	my $deployPayment = $deploy->getPayment();
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
	ok($sessionValue->getItsHash() eq "a977eb2d2e091823fccfc17bea195a55176f03a1f85599368620175d6bad9d04", "Test deploy session of type StoredContractByHash with hash a977EB2D2e091823fCCFC17bea195A55176F03a1f85599368620175d6BAd9d04- Passed");
	ok($sessionValue->getEntryPoint() eq "mint", "Test deploy session of type StoredContractByHash with entry_point: mint- Passed");
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
	# Assertion for first Arg - CLValue of type Key
	ok($oneNASession->getItsName() eq "recipient", "Test session first arg name = recipient - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "00d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test session first arg CLValue, bytes value = 00d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Key","Test session first arg CLValue, cl_type = Key - Passed");
	ok($sessionArgCLValue->getParse()->getItsValueStr() eq "account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269","Test payment first arg CLValue, parse = account-hash-d0bc9ca1353597c4004b8f881b397a89c1779004f5e547e04b57c2e7967c6269 - Passed");
	# Assertion for second Arg - CLValue of type List(U256)
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
			ok($parseValue->getItsValueStr() eq "2","Test session second arg CLValue, parse only element value is 2- Passed");
		} 
		$counter1 ++;
	}
	
	# Assertion for third Arg - CLValue of type List(Map(String,String))
	ok($oneNASession2->getItsName() eq "token_metas", "Test session third arg name = token_metas - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b","Test session third arg CLValue, bytes value = 010000000100000009000000746f6b656e5f7572695000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d5a4e7a337a564e7956333833666e315a6762726f78434c5378566e78376a727134796a4779464a6f5a35566b - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "List","Test session third arg CLValue, cl_type = List - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Map","Test session third arg CLValue, cl_type = List(Map) - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType1()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String) type String for map->key - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType2()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String) type String for map->value - Passed");	

	my @listCLParse2 = $sessionArgCLValue2->getParse()->getItsValueList();
	my $listLength2 = @listCLParse2;
	# assertion that the parse for clvalue List(Map(String,String)) is a list and the list is of 1 element, then the map is of 4 elements
	ok($listLength2 == 1,"Test session third arg CLValue, parse List(Map(String,String)) is a list of 1 elements- Passed");
	$counter1 = 0;
	my $counter2 = 0;
	foreach(@listCLParse2) {
		if($counter1 == 0) {
			# get first element of the list - is a clparse of type map
			my $parseValue2 = $_;
			# get the list of key for the clparse map
			my $parseKey = $parseValue2->getInnerParse1();
			my $parseValue = $parseValue2->getInnerParse2();
			my @listKey = $parseValue2->getInnerParse1()->getItsValueList();
			my @listValue = $parseValue2->getInnerParse2()->getItsValueList();
			my $totalKey = @listKey;
			# assertion for number of element in the map equal to 1
			ok($totalKey == 1,"Number of element in the map equals to 1 - Passed");
			# assertion for map - key values
			foreach(@listKey) {
				my $key = $_;
				if($counter2 == 0) {
					ok($key->getItsValueStr() eq "token_uri","Test session third arg CLValue of type List(Map(String,String)) with value of key = token_uri - Passed");					
				}
			}
			$counter2 = 0;
			foreach(@listValue) {
				my $value = $_;
				if($counter2 == 0) {
					ok($value->getItsValueStr() eq "https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk","Test session third arg CLValue of type List(Map(String,String)) with value of value = https://gateway.pinata.cloud/ipfs/QmZNz3zVNyV383fn1ZgbroxCLSxVnx7jrq4yjGyFJoZ5Vk - Passed");					
				}
			}
		}
	}
}

# Test 3: information for deploy at this address: https://testnet.cspr.live/deploy/430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e
# Test the following CLType: U64, List(String), ByteArray
sub getDeploy3 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("430df377ae04726de907f115bb06c52e40f6cd716b4b475a10e4cd9226d1317e");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeployResult($paramStr)->getDeploy();
	my $deployPayment = $deploy->getPayment();
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
			ok($parseValue->getItsValueStr() eq "hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0","Test session 3rd arg CLValue, parse first element value is hash-9B287f35b7C11659046cF575B13055DdE7F9A309cae5FE1cE3ca985d87f029b0- Passed");
		} elsif($counter1 == 1) {
			my $parseValue = $_;
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
	ok($sessionArgCLValue1->getParse()->getItsValueStr() eq "1642120827319","Test payment 5th arg CLValue, parse = 1642120827319 - Passed");
	# Assertion for third Arg
	ok($oneNASession2->getItsName() eq "target", "Test session 7th arg name = target - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f","Test session 7th arg CLValue, bytes value = 4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "ByteArray","Test session 7th arg CLValue, cl_type = ByteArray - Passed");
	ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f","Test payment 7 arg CLValue, parse = 4f4da49a080efdf3a66ddc279f050c0700618db675507734a46a8a1bb784575f - Passed");
}

# Test 4: information for deploy at this address: https://testnet.cspr.live/deploy/a91d468e2ddc8936f7866bc594794b322f747508c2192fd4eca90ef8a121d45e
# Test the following CLType: Option(List(String)), List(Map(String,String)) with value and with no value
sub getDeploy4 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("a91d468e2ddc8936f7866bc594794b322f747508c2192fd4eca90ef8a121d45e");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeployResult($paramStr)->getDeploy();
	my $deployPayment = $deploy->getPayment();
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "014caf1ce908f9ef3d427dceac17e5c47950becf15d1def0810c235e0d58a9efad","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "d7ffe9fa44f5958d18923630576302903f12ebee3e7516834d93b44ebf0454f9","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-17T11:11:08.508Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "30m","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "a91d468e2ddc8936f7866bc594794b322f747508c2192fd4eca90ef8a121d45e","Test deploy hash - Passed");
	
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
	ok($paymentFirstArgCLValue->getBytes() eq "0400ca9a3b","Test payment first arg CLValue - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "1000000000","Test payment first arg CLValue - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 3 element, but the list in Perl hold 3 + 2 = 5 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 4, "Test session total args - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession1;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 3) {
			$oneNASession = $_; # second NamedArg
		} elsif($counter1 == 4) {
			$oneNASession1 = $_;# third NamedArg
		}  elsif($counter1 == 5) {
			$oneNASession2 = $_;# fourth NamedArg
		}
		$counter1 ++;
	}
	# Assertion for second Arg
	ok($oneNASession->getItsName() eq "token_ids", "Test session second arg name - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "010100000018000000363165353465636231656366653538376561663963636530","Test session second arg CLValue, bytes value - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session second arg CLValue, cl_type Option - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "List","Test session second arg CLValue, cl_type = Option(List)- Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getInnerCLType1()->getItsTypeStr() eq "String","Test session second arg CLValue, cl_type = Option(List(String)) - Passed");
	my @listCLParse = $sessionArgCLValue->getParse()->getItsValueList();
	my $listLength = @listCLParse;
	# assertion that the parse for clvalue Option(List(String)) is a list and the list is of 1 element
	ok($listLength == 1,"Test session second arg CLValue, parse Option(List(String) is a list of 1 elements- Passed");
	$counter1 = 0;
	foreach(@listCLParse) {
		if($counter1 == 0) {
			my $parseValue = $_;
			ok($parseValue->getItsValueStr() eq "61e54ecb1ecfe587eaf9cce0","Test session second arg CLValue, parse first element value is 61e54ecb1ecfe587eaf9cce0 - Passed");
		}
	}
	
	# Assertion for third Arg
	ok($oneNASession1->getItsName() eq "token_metas", "Test session third arg name - Passed");
	my $sessionArgCLValue1 = $oneNASession1->getCLValue();
	ok($sessionArgCLValue1->getBytes() eq "0100000004000000040000006e616d650f000000546573742050726f642041646d696e0b0000006465736372697074696f6e0700000054657374696e6708000000697066735f75726c5000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d6175505535726338676868795a465178423952356a43626161664777324d6e65514a524d44574c567a6a615511000000697066735f6d657461646174615f75726c5000000068747470733a2f2f676174657761792e70696e6174612e636c6f75642f697066732f516d627279797641795664426d355a346e774133613738316d6d717563366e476165754541504b393661334c506e","Test session third arg CLValue, bytes value - Passed");
	ok($sessionArgCLValue1->getCLType()->getItsTypeStr() eq "List","Test session third arg CLValue, cl_type List - Passed");
	ok($sessionArgCLValue1->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Map","Test session third arg CLValue, cl_type = List(Map)- Passed");
	ok($sessionArgCLValue1->getCLType()->getInnerCLType1()->getInnerCLType1()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String)) key String - Passed");
	ok($sessionArgCLValue1->getCLType()->getInnerCLType1()->getInnerCLType2()->getItsTypeStr() eq "String","Test session third arg CLValue, cl_type = List(Map(String,String)) value String - Passed");
	my @listCLParse1 = $sessionArgCLValue1->getParse()->getItsValueList();
	my $listLength1 = @listCLParse1;
	# assertion that the parse for clvalue List(Map(String,String)) is a list and the list is of 1 element, then the map is of 4 elements
	ok($listLength1 == 1,"Test session third arg CLValue, parse List(Map(String,String)) is a list of 1 elements- Passed");
	$counter1 = 0;
	my $counter2 = 0;
	foreach(@listCLParse1) {
		if($counter1 == 0) {
			# get first element of the list - is a clparse of type map
			my $parseValue2 = $_;
			# get the list of key for the clparse map
			my $parseKey = $parseValue2->getInnerParse1();
			my $parseValue = $parseValue2->getInnerParse2();
			my @listKey = $parseValue2->getInnerParse1()->getItsValueList();
			my @listValue = $parseValue2->getInnerParse2()->getItsValueList();
			my $totalKey = @listKey;
			# assertion for number of element in the map equal to 4
			ok($totalKey == 4,"Number of element in the map equals to 4 - Passed");
			# assertion for map - key values
			foreach(@listKey) {
				my $key = $_;
				if($counter2 == 0) {
					ok($key->getItsValueStr() eq "name","Test session third arg CLValue of type List(Map(String,String)) with value of key = name - Passed");					
				}
				if($counter2 == 1) {
					ok($key->getItsValueStr() eq "description","Test session third arg CLValue of type List(Map(String,String)) with value of key = description - Passed");					
				}
				if($counter2 == 2) {
					ok($key->getItsValueStr() eq "ipfs_url","Test session third arg CLValue of type List(Map(String,String)) with value of key = ipfs_url - Passed");					
				}
				if($counter2 == 3) {
					ok($key->getItsValueStr() eq "ipfs_metadata_url","Test session third arg CLValue of type List(Map(String,String)) with value of key = ipfs_metadata_url - Passed");					
				}
				$counter2 ++;
			}
			# assertion for map - value values
			$counter2 = 0;
			foreach(@listValue) {
				my $value = $_;
				if($counter2 == 0) {
					ok($value->getItsValueStr() eq "Test Prod Admin","Test session third arg CLValue of type List(Map(String,String)) with value of value = Test Prod Admin - Passed");					
				}
				if($counter2 == 1) {
					ok($value->getItsValueStr() eq "Testing","Test session third arg CLValue of type List(Map(String,String)) with value of value = Testing - Passed");					
				}
				if($counter2 == 2) {
					ok($value->getItsValueStr() eq "https://gateway.pinata.cloud/ipfs/QmauPU5rc8ghhyZFQxB9R5jCbaafGw2MneQJRMDWLVzjaU","Test session third arg CLValue of type List(Map(String,String)) with value of value = https://gateway.pinata.cloud/ipfs/QmauPU5rc8ghhyZFQxB9R5jCbaafGw2MneQJRMDWLVzjaU - Passed");					
				}
				if($counter2 == 3) {
					ok($value->getItsValueStr() eq "https://gateway.pinata.cloud/ipfs/QmbryyvAyVdBm5Z4nwA3a781mmquc6nGaeuEAPK96a3LPn","Test session third arg CLValue of type List(Map(String,String)) with value of value = https://gateway.pinata.cloud/ipfs/QmbryyvAyVdBm5Z4nwA3a781mmquc6nGaeuEAPK96a3LPn - Passed");					
				}
				$counter2 ++;
			}
		}
		$counter1 ++;
	}
	
	# Assertion for 4th Arg
	ok($oneNASession2->getItsName() eq "token_commissions", "Test session 4th arg name - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "0100000000000000","Test session 4th arg CLValue, bytes value - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "List","Test session 4th arg CLValue, cl_type List - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Map","Test session 4th arg CLValue, cl_type = List(Map)- Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType1()->getItsTypeStr() eq "String","Test session 4th arg CLValue, cl_type = List(Map(String,String)) key String - Passed");
	ok($sessionArgCLValue2->getCLType()->getInnerCLType1()->getInnerCLType2()->getItsTypeStr() eq "String","Test session 4th arg CLValue, cl_type = List(Map(String,String)) value String - Passed");
	my @listCLParse2 = $sessionArgCLValue2->getParse()->getItsValueList();
	$counter1 = 0;
	# assertion that the parse for clvalue List(Map(String,String)) is a list and the list is of 0 element, then the map is of 4 elements
	foreach(@listCLParse2) {
		if($counter1 == 0) {
			# get first element of the list - is a clparse of type map
			my $parseValue2 = $_;
			# get the list of key for the clparse map
			my @listKey2 = $parseValue2->getInnerParse1()->getItsValueList();
			my $numOfItem = @listKey2;
			ok($numOfItem == 0,"Test session 4th arg CLValue, parse List(Map(String,String)) is a list of 0 elements- Passed");
		}
		$counter1 ++;
	}
	
}

# Test 5: information for deploy at this address: https://testnet.cspr.live/deploy/9ff98d8027795a002e41a709d5b5846e49c2e9f9c8bfbe74e4c857adc26d5571
# Test the following CLType: Option(U512), U32, Option(U64) and Option(Bool) with NULL value, U64, String
sub getDeploy5 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("9ff98d8027795a002e41a709d5b5846e49c2e9f9c8bfbe74e4c857adc26d5571");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeployResult($paramStr)->getDeploy();
	my $deployPayment = $deploy->getPayment();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "014caf1ce908f9ef3d427dceac17e5c47950becf15d1def0810c235e0d58a9efad","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "9230c6b1b15cc56a35c52e63141ffe81ae5042395e5b096b7d107b4df3ed0ae5","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-25T13:47:28.227Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "30m","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "9ff98d8027795a002e41a709d5b5846e49c2e9f9c8bfbe74e4c857adc26d5571","Test deploy hash - Passed");
	
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
	ok($paymentFirstArgCLValue->getBytes() eq "0500d0ed902e","Test payment first arg CLValue, bytes value = 0500d0ed902e - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "200000000000","Test payment first arg CLValue, parse = 200000000000 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "ModuleBytes", "Test deploy session of type ModuleBytes - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 17 element, but the list in Perl hold 17 + 2 = 19 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 17, "Test session total args = 17 - Passed");
	$counter1 = -2;
	my $oneNASession;
	foreach(@listArgsSession) {
		if($counter1 == 4) { # get CLValue of type Option(Bool) with value NULL
			$oneNASession = $_;
			# Assertion for 5th Arg - CLType of type Option(Bool)
			ok($oneNASession->getItsName() eq "starting_price", "Test session 5th arg name = starting_price - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "00","Test session 5th arg CLValue, bytes value = 00 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 5th arg CLValue, cl_type = Option - Passed");
			ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Bool","Test session 9th arg CLValue, cl_type = Option(Bool) Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "NULL_VALUE","Test session 9th arg CLValue, parse = NULL - Passed");
		} elsif($counter1 == 12) { # get CLValue of type Option(U64) with value NULL
			$oneNASession = $_;
			ok($oneNASession->getItsName() eq "bidder_count_cap", "Test session 13th arg name = bidder_count_cap - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "00","Test session 13th arg CLValue, bytes value = 00 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 13th arg CLValue, cl_type = Option - Passed");
			ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "U64","Test session 13th arg CLValue, cl_type = Option(U64) Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "NULL_VALUE","Test session 13th arg CLValue, parse = NULL - Passed");
		} elsif($counter1 == 14) { 
			$oneNASession = $_;
			# Assertion for 15th Arg - CLType of type Option(U512) with value 5
			ok($oneNASession->getItsName() eq "minimum_bid_step", "Test session 15th arg name = minimum_bid_step - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "010105","Test session 13th arg CLValue, bytes value = 010105 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 15th arg CLValue, cl_type = Option - Passed");
			ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "U512","Test session 15th arg CLValue, cl_type = Option(U512) Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "5","Test session 15th arg CLValue, parse = 5 - Passed");
		}
		elsif($counter1 == 16) { # get CLValue of type U32
			$oneNASession = $_;
			# Assertion for 17th Arg - CLType of type U32  with value 100
			ok($oneNASession->getItsName() eq "marketplace_commission", "Test session 17th arg name = marketplace_commission - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "64000000","Test session 17th arg CLValue, bytes value = 64000000 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "U32","Test session 17th arg CLValue, cl_type = U32 - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "100","Test session 17th arg CLValue, parse = 100 - Passed");
		} elsif($counter1 == 10) { # get CLValue of type String
			$oneNASession = $_;
			# Assertion for 11th Arg - CLType of type String  with value 100
			ok($oneNASession->getItsName() eq "format", "Test session 11th arg name = format - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "07000000454e474c495348","Test session 11th arg CLValue, bytes value = 07000000454e474c495348 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "String","Test session 11th arg CLValue, cl_type = String - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "ENGLISH","Test session 11th arg CLValue, parse = ENGLISH - Passed");
		}
		$counter1 ++;
	}
	#Approvals assertion
	my @listApproval = $deploy->getApprovals();
	$counter1 = 0;
	foreach(@listApproval) {
		if($counter1 == 0) {
			my @oneApproval = @{$_};
			my $totalApproval = @oneApproval;
			ok($totalApproval == 1, "Test total approval = 1, Passed");
			foreach(@oneApproval) {
				my $oA = $_;
				ok($oA->getSigner() eq "014caf1ce908f9ef3d427dceac17e5c47950becf15d1def0810c235e0d58a9efad", "Test approval signer - Passed");
				ok($oA->getSignature() eq "011f547186d73f9b47de744e2d83294863667153bbc9e17d2d93b81c2a534baea889ccea44ae75c5078ed96930accd795982ed038781f8122c07dafde418117a00", "Test approval signature - Passed");
			}
		}
		$counter1 ++;
	}
}

# Test 6: information for deploy at this address: https://testnet.cspr.live/deploy/1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f
# Test the following CLType: U512, U256, Key, Option(Key)
# Test Transform of the following type:
# Identity, WriteCLValue, AddUInt512, AddKeys, WriteDeployInfo
sub getDeploy6 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
	my $deploy = $getDeployResult->getDeploy();
	my $deployPayment = $deploy->getPayment();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "013112068231a00e12e79b477888ae1f3b2dca40d6e2de17de4174534bc3a5143b","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "2b2c41ed3f20b6949572a391655151407b744c0331ef1994f590f15bb19f14bf","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-25T13:03:53.438Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "1h","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 10,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f","Test deploy hash - Passed");
	
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
	ok($paymentFirstArgCLValue->getBytes() eq "0500743ba40b","Test payment first arg CLValue, bytes value = 0500743ba40b - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "50000000000","Test payment first arg CLValue, parse = 50000000000 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	ok($sessionValue->getItsHash() eq "29710161f8912257718fc2f9a8cf80a55b82f706d22609cb8190c83de01bd690", "Test deploy session of type StoredContractByHash with hash 29710161f8912257718fc2f9a8cf80a55b82f706d22609cb8190c83de01bd690- Passed");
	ok($sessionValue->getEntryPoint() eq "issueDemoVC", "Test deploy session of type StoredContractByHash with entry_point: issueDemoVC- Passed");
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 5 element, but the list in Perl hold 5 + 2 = 7 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 5, "Test session total args = 5 - Passed");
	$counter1 = -2;
	my $oneNASession;
	foreach(@listArgsSession) {
		if($counter1 == 4) { # get CLValue of type Option(Bool) with value NULL
			$oneNASession = $_;
			# Assertion for 5th Arg - CLType of type Option(Bool)
			ok($oneNASession->getItsName() eq "revocationFlag", "Test session 5th arg name = revocationFlag - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "01","Test session 5th arg CLValue, bytes value = 00 - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Bool","Test session 5th arg CLValue, cl_type = Bool - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "1","Test session 5th arg CLValue, parse = true - Passed");
		} 
		$counter1 ++;
	}
	#Approvals assertion
	my @listApproval = $deploy->getApprovals();
	$counter1 = 0;
	foreach(@listApproval) {
		if($counter1 == 0) {
			my @oneApproval = @{$_};
			my $totalApproval = @oneApproval;
			ok($totalApproval == 1, "Test total approval = 1, Passed");
			foreach(@oneApproval) {
				my $oA = $_;
				ok($oA->getSigner() eq "013112068231a00e12e79b477888ae1f3b2dca40d6e2de17de4174534bc3a5143b", "Test approval signer - Passed");
				ok($oA->getSignature() eq "01e3cf17faf54d7145d64c4cb446f75d82ad673b2d76105116b621f7dc853eb6e169163ec9a360505484ca176b333a3958c02d3b47300a6fded81412736196fa02", "Test approval signature - Passed");
			}
		}
		$counter1 ++;
	}
	# JsonExecutionResult list assertion
	# Test Transform of the following type:
	# Identity, WriteCLValue, AddUInt512, AddKeys, WriteDeployInfo
	my @list =  $getDeployResult->getExecutionResults();
	my $totalER = @list;
	ok ($totalER == 1, "Test total JsonExecutionResult = 1, Passed");
	$counter1 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "966b9cbc817b01974847b0ae536902c6dc90af9c4ff47ec4bc43ee9b095a4359", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "721839840", "Test ExecutionResult cost, Passed");
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 32, "Test total Transform = 32, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type Identify
				if($counter2 == 0) { # Test CasperTransform of type Identity
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "hash-8cf5e4acf51f54eb59291599187838dc3bc234089c46fc6ca8ad17e762ae4401","Test first TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type Identity
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_IDENTITY,"Test first transform of type Identity, Passed");
				} elsif($counter2 == 6) { # Test CasperTransform of type WriteCLValue
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "balance-fbd34b977fb27d90e25d3ac48ec27450c91bf499e785f7b4278de8dd08299ed5","Test 7th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteCLValue
					ok($oneT->getItsType() eq "WriteCLValue","Test 7th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "0500378cb47d","Test 7th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq "U512","Test 7th transform of type WriteCLValue and CLValue clType of U512, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "539900000000","Test 7th transform of type WriteCLValue and CLValue clParsed, Passed");
				} elsif($counter2 == 7) { # Test CasperTransform of type AddUInt512
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "balance-98d945f5324f865243b7c02c0417ab6eac361c5c56602fd42ced834a1ba201b6","Test 8th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type Identity
					ok($oneT->getItsType() eq "AddUInt512","Test 8th transform of type AddUInt512, Passed");
					ok($oneT->getItsValue() eq "50000000000", "Test 8th transform of type AddUInt512 and check value, Passed");
				} elsif($counter2 == 9) { # Test CasperTransform of type WriteCLValue
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-80b4d672233751de4ffb8e23f70fd23c30a06ca08b67e79d3bc0bd3f3af3bd6b-000","Test 10th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteCLValue
					ok($oneT->getItsType() eq "WriteCLValue","Test 10th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "bde21f5eb8bd073acdfa59ac7d613f865cd101ccaf3d787cb5dc909f0111a9c2","Test 10th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq "ByteArray","Test 10th transform of type WriteCLValue and CLValue clType of ByteArray, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "bde21f5eb8bd073acdfa59ac7d613f865cd101ccaf3d787cb5dc909f0111a9c2","Test 10th transform of type WriteCLValue and CLValue clParsed, Passed");
				}
				elsif($counter2 == 17) { # Test CasperTransform of type WriteCLValue
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-ae38db81f46023ff9e0acc12ce97973114797070dc6813c436dfd54dace6f214-000","Test 18th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteCLValue
					ok($oneT->getItsType() eq "WriteCLValue","Test 18th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "01","Test 18th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq "Bool","Test 18th transform of type WriteCLValue and CLValue clType of Bool, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "1","Test 18th transform of type WriteCLValue and CLValue clParsed, Passed");
				} elsif($counter2 == 23) { # Test CasperTransform of type WriteDeployInfo
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "deploy-1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f","Test 24th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteDeployInfo
					ok($oneT->getItsType() eq "WriteDeployInfo","Test 24th transform of type WriteDeployInfo, Passed");
					my $deployInfo = $oneT->getItsValue();
					ok($deployInfo->getDeployHash() eq "1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f", "Test WriteDeployInfo, deploy_hash, Passed ");
					ok($deployInfo->getFrom() eq "account-hash-2bb951609cf7bea4b9fee202ba2e8719c3453ed53ed0a19289063665c61b637a", "Test WriteDeployInfo, from, Passed ");
					ok($deployInfo->getSource() eq "uref-fbd34b977fb27d90e25d3ac48ec27450c91bf499e785f7b4278de8dd08299ed5-007", "Test WriteDeployInfo, source, Passed ");
					ok($deployInfo->getGas() eq "721839840", "Test WriteDeployInfo gas, Passed ");
					my @transfer = $deployInfo->getTransfers();
					my $totalTransfer = @transfer;
					ok($totalTransfer == 0, "Test WriteDeployInfo total transfer = 0, Passed ");
				}
				$counter2 ++;
			}
		}
	}
}

# Test 7: information for deploy at this address: https://testnet.cspr.live/deploy/1d113022631c587444166e4d1efbc3d475e49b28b90f1414d9cadee6dcddf65f
# Test the following CLType: U8, List(ByteArray), List(U8)
# Test Transform of the following type:
# WriteAccount
sub getDeploy7 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("ac654d996f17720e780fe4eae9a7d57d57cdadb069998666a369a0833aebb7f8");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
	my $deploy = $getDeployResult->getDeploy();
	my $deployPayment = $deploy->getPayment();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "02035f1c6d78e727edc1901080b812dbee429ea8365cbfbc0ed6a4238673646630cf","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "a58193df33677d04b684ca0d4efc725c1f02cfc51b1dd8cc9a6f5d36f7440542","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-15T06:41:47.633Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "1day","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "ac654d996f17720e780fe4eae9a7d57d57cdadb069998666a369a0833aebb7f8","Test deploy hash - Passed");
	
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
	ok($paymentFirstArgCLValue->getBytes() eq "0400ca9a3b","Test payment first arg CLValue, bytes value - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "1000000000","Test payment first arg CLValue, parse - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "ModuleBytes", "Test deploy session of type ModuleBytes - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 9 element, but the list in Perl hold 9 + 2 = 11 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 9, "Test session total args = 5 - Passed");
	$counter1 = -2;
	my $oneNASession;
	foreach(@listArgsSession) {
		if($counter1 == 1) { # get CLValue of type U8
			$oneNASession = $_;
			# Assertion for 2nd Arg - CLType of type U8
			ok($oneNASession->getItsName() eq "deployment_thereshold", "Test session 2nd arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "02","Test session 2nd arg CLValue, bytes value  - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "U8","Test session 2nd arg CLValue, cl_type  - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "2","Test session 2nd arg CLValue, parse - Passed");
		} elsif($counter1 == 2) { # get CLValue of type U8
			$oneNASession = $_;
			# Assertion for 3rd Arg - CLType of type U8
			ok($oneNASession->getItsName() eq "key_management_threshold", "Test session 3rd arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "03","Test session 3rd arg CLValue, bytes value  - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "U8","Test session 3rd arg CLValue, cl_type  - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "3","Test session 3rd arg CLValue, parse - Passed");
		} elsif($counter1 == 3) { # get CLValue of type List(ByteArray)
			$oneNASession = $_;
			# Assertion for 4th Arg - CLType of type List(ByteArray)
			ok($oneNASession->getItsName() eq "accounts", "Test session 4th arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "04000000cc77e0fef426adc63f5380d13e20ab62832f70afae299bef6fcf3f985eb6e5937aebb6de622b00ced00fc0ed16562b5c0d7ee3a3a894fc42001eb7fb2da4d102713910b4d6f4fed1ab28b06e93c2562f845c570ac6861b93bee6a67f4aeedb035c6c49477ffa1dabc642d4cc894a21b248e721ee66128c59588393acea1ff196","Test session 4th arg CLValue, bytes value  - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "List","Test session 4th arg CLValue, cl_type List - Passed");
			ok($sessionArgCLValue->getCLType()->setInnerCLType1()->getItsTypeStr() eq "ByteArray","Test session 4th arg CLValue, cl_type List(ByteArray)  - Passed");

			my @listCLParse1 = $sessionArgCLValue->getParse()->getItsValueList();
			my $listLength1 = @listCLParse1;
			# assertion that the parse for clvalue List(Map(String,String)) is a list and the list is of 1 element, then the map is of 4 elements
			ok($listLength1 == 4,"Test session 4th arg CLValue, parse List(ByteArray) is a list of 4 elements- Passed");
			my $counter2 = 0;
			my $parseValue2;
			foreach(@listCLParse1) {
				$parseValue2 = $_;
				if($counter2 == 0) {
					ok($parseValue2->getItsValueStr() eq "cc77e0fef426adc63f5380d13e20ab62832f70afae299bef6fcf3f985eb6e593", "Test firt element in List(ByteArray) value, Passed");
				} elsif($counter2 == 1) {
					ok($parseValue2->getItsValueStr() eq "7aebb6de622b00ced00fc0ed16562b5c0d7ee3a3a894fc42001eb7fb2da4d102", "Test firt element in List(ByteArray) value, Passed");
				} elsif($counter2 == 2) {
					ok($parseValue2->getItsValueStr() eq "713910b4d6f4fed1ab28b06e93c2562f845c570ac6861b93bee6a67f4aeedb03", "Test firt element in List(ByteArray) value, Passed");
				} elsif($counter2 == 3) {
					ok($parseValue2->getItsValueStr() eq "5c6c49477ffa1dabc642d4cc894a21b248e721ee66128c59588393acea1ff196", "Test firt element in List(ByteArray) value, Passed");
				}
				$counter2 ++;
			}	
		} 
		$counter1 ++;
	}
	#Approvals assertion
	my @listApproval = $deploy->getApprovals();
	$counter1 = 0;
	foreach(@listApproval) {
		if($counter1 == 0) {
			my @oneApproval = @{$_};
			my $totalApproval = @oneApproval;
			ok($totalApproval == 1, "Test total approval = 1, Passed");
			foreach(@oneApproval) {
				my $oA = $_;
				ok($oA->getSigner() eq "02035f1c6d78e727edc1901080b812dbee429ea8365cbfbc0ed6a4238673646630cf", "Test approval signer - Passed");
				ok($oA->getSignature() eq "0247cbc2d683782079b17fdf26d207b47bc549c676d0cd4532b7af19ab601e8fb8031c0f5fd10735a96c5d939c55b4ce5ba301d02cb651b9e4213c81d98a60997e", "Test approval signature - Passed");
			}
		}
		$counter1 ++;
	}
	# JsonExecutionResult list assertion
	# Test Transform of the following type:
	# Identity, WriteCLValue, AddUInt512, AddKeys, WriteDeployInfo
	my @list =  $getDeployResult->getExecutionResults();
	my $totalER = @list;
	ok ($totalER == 1, "Test total JsonExecutionResult = 1, Passed");
	$counter1 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "04e5233a6d15dd77eb4193bf112d4e47b204f24cef4a3b7d43a23dd2ad611c47", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "667974020", "Test ExecutionResult cost, Passed");
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 32, "Test total Transform = 32, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteAccount
				if($counter2 == 10) { # Test CasperTransform of type WriteAccount
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "account-hash-5c6c49477ffa1dabc642d4cc894a21b248e721ee66128c59588393acea1ff196","Test 11th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteAccount
					ok($oneT->getItsType() eq "WriteAccount","Test 11th transform of type WriteAccount, Passed");
					ok($oneT->getItsValue() eq "account-hash-5c6c49477ffa1dabc642d4cc894a21b248e721ee66128c59588393acea1ff196","Test value 11th transform of type WriteAccount, Passed");
				}
				$counter2 ++;
			}
		}
	}
}
# Test 8: information for deploy at this address: 
# https://testnet.cspr.live/deploy/fa02357bffd204b34d3a3495f393fc5651541e1be4376072d6d94297daa688d6
# Test the following CLType: PublicKey
# Sesssion of type Transfer
# Test Transform of the following type:
# WriteTransfer, WriteDeployInfo
sub getDeploy8 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("fa02357bffd204b34d3a3495f393fc5651541e1be4376072d6d94297daa688d6");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
	my $deploy = $getDeployResult->getDeploy();
	
	#Test assertion for Deploy session
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "Transfer", "Test deploy session of type Transfer - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 3 element, but the list in Perl hold 3 + 2 = 5 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 3, "Test session total args = 3 - Passed");
	my $counter1 = -2;
	my $oneNASession;
	foreach(@listArgsSession) {
		if($counter1 == 1) { # get CLValue of type Option(Bool) with value NULL
			$oneNASession = $_;
			# Assertion for 5th Arg - CLType of type Option(Bool)
			ok($oneNASession->getItsName() eq "target", "Test session 2nd arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "01394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b","Test session 5th arg CLValue, bytes value - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "PublicKey","Test session 2nd arg CLValue, cl_type - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "01394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b","Test session 2nd arg CLValue, parse - Passed");
		} 
		$counter1 ++;
	}
	#Approvals assertion
	my @listApproval = $deploy->getApprovals();
	$counter1 = 0;
	foreach(@listApproval) {
		if($counter1 == 0) {
			my @oneApproval = @{$_};
			my $totalApproval = @oneApproval;
			ok($totalApproval == 1, "Test total approval = 1, Passed");
			foreach(@oneApproval) {
				my $oA = $_;
				ok($oA->getSigner() eq "0203e15e061bbf79491df84130192a711e541ce078b1c7deb46bf42194cc1cc7900f", "Test approval signer - Passed");
				ok($oA->getSignature() eq "0215fe5e8fc7f5a63ad08bbe84409cfc67ca2360c01db99c9964ae023496f00157033d28dee9949b1ccd508fe22f741ab6c4a77921d735b2e026e5c52932a3b6e0", "Test approval signature - Passed");
			}
		}
		$counter1 ++;
	}
	# JsonExecutionResult list assertion
	# Test Transform of the following type:
	# Identity, WriteCLValue, AddUInt512, AddKeys, WriteDeployInfo
	my @list =  $getDeployResult->getExecutionResults();
	my $totalER = @list;
	ok ($totalER == 1, "Test total JsonExecutionResult = 1, Passed");
	$counter1 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "cce6e59744490b3d28b1c92d6526f280a787586ae1e73efa22f7093e4e8b7dfc", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult(); # ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "100000000", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 1, "Test ExecutionResult transfer list of 1 element, Passed");
			foreach(@listTransfer) {
				ok($_ eq "transfer-38c24e8f3871fa3d3a30db11a0a41681f030ff3dccc252da4e4ac585bb878324","Test ExecutionResult transfer list first element value, Passed");
			}
			# assertion for ExecutionResult
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 26, "Test total Transform = 26, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteTransfer
				if($counter2 == 16) { # Test CasperTransform of type WriteTransfer
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "transfer-38c24e8f3871fa3d3a30db11a0a41681f030ff3dccc252da4e4ac585bb878324","Test 17th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteTransfer
					ok($oneT->getItsType() eq "WriteTransfer","Test 17th transform of type WriteTransfer, Passed");
					my $casperTransfer = $oneT->getItsValue();
					ok($casperTransfer->getDeployHash() eq "fa02357bffd204b34d3a3495f393fc5651541e1be4376072d6d94297daa688d6","Test 17th transform of type WriteTransfer - deploy_hash, Passed");
					ok($casperTransfer->getId() eq "1642167289561","Test 17th transform of type WriteTransfer - id, Passed");
					ok($casperTransfer->getTo() eq "account-hash-7842eb5731da8182773633e6a9aef0a42d031eb259add2b235d617514461d753","Test 17th transform of type WriteTransfer - to, Passed");
					ok($casperTransfer->getGas() eq "0","Test 17th transform of type WriteTransfer - gas, Passed");
					ok($casperTransfer->getFrom() eq "account-hash-ab56d6da16d47a23fc07db7abc569f1be6b420683fafcbf654d71a4518cf0579","Test 17th transform of type WriteTransfer - from, Passed");
					ok($casperTransfer->getAmount() eq "999900000000","Test 17th transform of type WriteTransfer - amount, Passed");
					ok($casperTransfer->getSource() eq "uref-2f72a310a1443d615f56f829bfe6147b72a5874fd28ccf8af17abd4c65d35b86-007","Test 17th transform of type WriteTransfer - source, Passed");
					ok($casperTransfer->getTarget() eq "uref-f06b78af308d9b5e17d9494587a05c9e736ed82b9e033ea94c592eab8f00f702-004","Test 17th transform of type WriteTransfer - target, Passed");
					
				} elsif($counter2 == 17) { # Test CasperTransform of type WriteDeployInfo
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "deploy-fa02357bffd204b34d3a3495f393fc5651541e1be4376072d6d94297daa688d6","Test 24th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteDeployInfo
					ok($oneT->getItsType() eq "WriteDeployInfo","Test 24th transform of type WriteDeployInfo, Passed");
					my $deployInfo = $oneT->getItsValue();
					ok($deployInfo->getDeployHash() eq "fa02357bffd204b34d3a3495f393fc5651541e1be4376072d6d94297daa688d6", "Test WriteDeployInfo, deploy_hash, Passed ");
					ok($deployInfo->getFrom() eq "account-hash-ab56d6da16d47a23fc07db7abc569f1be6b420683fafcbf654d71a4518cf0579", "Test WriteDeployInfo, from, Passed ");
					ok($deployInfo->getSource() eq "uref-2f72a310a1443d615f56f829bfe6147b72a5874fd28ccf8af17abd4c65d35b86-007", "Test WriteDeployInfo, source, Passed ");
					ok($deployInfo->getGas() eq "100000000", "Test WriteDeployInfo gas, Passed ");
					my @transfer = $deployInfo->getTransfers();
					my $totalTransfer = @transfer;
					ok($totalTransfer == 1, "Test WriteDeployInfo total transfer = 1, Passed ");
					foreach(@transfer) {
						ok($_ eq "transfer-38c24e8f3871fa3d3a30db11a0a41681f030ff3dccc252da4e4ac585bb878324", "Test WriteDeployInfo first Transfer value, Passed ");
					}
				}
				$counter2 ++;
			}
		}
	}
}

# Test 9: information for deploy at this address: 
# https://testnet.cspr.live/deploy/f19c1b8de8f5165df43c61ac4ee00a975e0d86154d55333254d30ea5f59fab8d
# Test the following CLType: Unit - with Null value
# Test Transform of the following type:
# WriteTransfer, WriteDeployInfo
sub getDeploy9 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("f19c1b8de8f5165df43c61ac4ee00a975e0d86154d55333254d30ea5f59fab8d");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
	my $deploy = $getDeployResult->getDeploy();
	
	
	# JsonExecutionResult list assertion
	# Test Transform of the following type:
	# Identity, WriteCLValue, AddUInt512, AddKeys, WriteDeployInfo
	my @list =  $getDeployResult->getExecutionResults();
	my $totalER = @list;
	ok ($totalER == 1, "Test total JsonExecutionResult = 1, Passed");
	my $counter1 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "1847e60fdec3f55880de0ccd12df901f5824f4bdd47347f78038dccd16d06516", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "2668483540", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 1, "Test ExecutionResult transfer list of 1 element, Passed");
			foreach(@listTransfer) {
				ok($_ eq "transfer-92dad51dd060c87b1631bbfa503f7753d621b298663382580ee753c02c0531de","Test ExecutionResult transfer list first element value, Passed");
			}
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 32, "Test total Transform = 32, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteCLValue Unit - null value
				if ($counter2 == 11) {
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-d68c0c2551b44290b70ab231a3521730585adb7d567e9e604747d64f6ada7dc6-000","Test 12th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteCLValue
					ok($oneT->getItsType() eq "WriteCLValue","Test 12th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "","Test 12th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq "Unit","Test 12th transform of type WriteCLValue and CLValue clType of Unit, Passed");
					ok($clValue->getParse()->getItsValueStr() eq $Common::ConstValues::NULL_VALUE,"Test 12th transform of type WriteCLValue and CLValue clParsed Unit with NULL value, Passed");
				}
				if($counter2 == 19) { # Test CasperTransform of type WriteTransfer
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "transfer-92dad51dd060c87b1631bbfa503f7753d621b298663382580ee753c02c0531de","Test 17th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteTransfer
					ok($oneT->getItsType() eq "WriteTransfer","Test 17th transform of type WriteTransfer, Passed");
					my $casperTransfer = $oneT->getItsValue();
					ok($casperTransfer->getDeployHash() eq "f19c1b8de8f5165df43c61ac4ee00a975e0d86154d55333254d30ea5f59fab8d","Test 17th transform of type WriteTransfer - deploy_hash, Passed");
					ok($casperTransfer->getTo() eq "account-hash-9c45726dd9eb1510feeebf0f569b05fd5b8792c7afead521f1adf4d59ed85c81","Test 17th transform of type WriteTransfer - to, Passed");
					ok($casperTransfer->getGas() eq "0","Test 17th transform of type WriteTransfer - gas, Passed");
					ok($casperTransfer->getFrom() eq "account-hash-b383c7cc23d18bc1b42406a1b2d29fc8dba86425197b6f553d7fd61375b5e446","Test 17th transform of type WriteTransfer - from, Passed");
					ok($casperTransfer->getAmount() eq "1000000000000","Test 17th transform of type WriteTransfer - amount, Passed");
					ok($casperTransfer->getSource() eq "uref-b06a1ab0cfb52b5d4f9a08b68a5dbe78e999de0b0484c03e64f5c03897cf637b-007","Test 17th transform of type WriteTransfer - source, Passed");
					ok($casperTransfer->getTarget() eq "uref-d68c0c2551b44290b70ab231a3521730585adb7d567e9e604747d64f6ada7dc6-004","Test 17th transform of type WriteTransfer - target, Passed");
				} elsif($counter2 == 23) { # Test CasperTransform of type WriteDeployInfo
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "deploy-f19c1b8de8f5165df43c61ac4ee00a975e0d86154d55333254d30ea5f59fab8d","Test 24th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteDeployInfo
					ok($oneT->getItsType() eq "WriteDeployInfo","Test 24th transform of type WriteDeployInfo, Passed");
					my $deployInfo = $oneT->getItsValue();
					ok($deployInfo->getDeployHash() eq "f19c1b8de8f5165df43c61ac4ee00a975e0d86154d55333254d30ea5f59fab8d", "Test WriteDeployInfo, deploy_hash, Passed ");
					ok($deployInfo->getFrom() eq "account-hash-b383c7cc23d18bc1b42406a1b2d29fc8dba86425197b6f553d7fd61375b5e446", "Test WriteDeployInfo, from, Passed ");
					ok($deployInfo->getSource() eq "uref-b06a1ab0cfb52b5d4f9a08b68a5dbe78e999de0b0484c03e64f5c03897cf637b-007", "Test WriteDeployInfo, source, Passed ");
					ok($deployInfo->getGas() eq "2668483540", "Test WriteDeployInfo gas, Passed ");
					my @transfer = $deployInfo->getTransfers();
					my $totalTransfer = @transfer;
					ok($totalTransfer == 1, "Test WriteDeployInfo total transfer = 1, Passed ");
					foreach(@transfer) {
						ok($_ eq "transfer-92dad51dd060c87b1631bbfa503f7753d621b298663382580ee753c02c0531de", "Test WriteDeployInfo first Transfer value, Passed ");
					}
				}
				$counter2 ++;
			}
		}
	}
}
getDeploy1();
#getDeploy2();
#getDeploy3();
#getDeploy4();
#getDeploy5();
#getDeploy6();
#getDeploy7();
#getDeploy8();
#getDeploy9();

