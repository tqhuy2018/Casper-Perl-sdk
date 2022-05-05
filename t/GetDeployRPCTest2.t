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
# Test 10: information for deploy at this address: https://testnet.cspr.live/deploy/0fe0adccf645e99b9b58493c843516cd354b189e1c3efe62c4f2768716a41932
# Test the following CLType: Any with Null value, Map(String,String), URef
# Test Transform of the following type:
# WriteAccount
sub getDeploy10 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("0fe0adccf645e99b9b58493c843516cd354b189e1c3efe62c4f2768716a41932");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
	my $deploy = $getDeployResult->getDeploy();
	my $deployPayment = $deploy->getPayment();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "010e23504a0992308df898fe53ee2c1ab150544337dac2af0b15c2d5c148caaa42","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "0bd06ec6ab769b6585a447dd087819344e36c1badd78d226531ea02f21015625","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-01-14T14:26:56.299Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "5h","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "0fe0adccf645e99b9b58493c843516cd354b189e1c3efe62c4f2768716a41932","Test deploy hash - Passed");
	
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
	ok($paymentFirstArgCLValue->getBytes() eq "0500eaa55a01","Test payment first arg CLValue, bytes value - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "5815790080","Test payment first arg CLValue, parse - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	# The real args list contains 6 element, but the list in Perl hold 6 + 2 = 8 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 6, "Test session total args = 6 - Passed");
	$counter1 = -2;
	my $oneNASession;
	foreach(@listArgsSession) {
		if($counter1 == 5) { # get CLValue of type URef
			$oneNASession = $_;
			# Assertion for 6th Arg - CLType of type URef
			ok($oneNASession->getItsName() eq "src_purse", "Test session 6th arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c607","Test session 6th arg CLValue, bytes value  - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_UREF,"Test session 6th arg CLValue, cl_type  - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007","Test session 6th arg CLValue, parse - Passed");
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
				ok($oA->getSigner() eq "010e23504a0992308df898fe53ee2c1ab150544337dac2af0b15c2d5c148caaa42", "Test approval signer - Passed");
				ok($oA->getSignature() eq "01a201b610c1c3445eb1f931e29a1d32aeb51d66155d1edd9347ced6341a35d76473a723beace9806c46f1556c636901fb5dd8b2b7a8c3179f1278d61d2870950a", "Test approval signature - Passed");
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
	my $counter2 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "a8793c584560edb605339c8d36c29ec31bb4d7643985e3f38901a7615d95baef", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "2630895530", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 2, "Test ExecutionResult transfer list of 2 element, Passed");
			foreach(@listTransfer) {
				if($counter2 == 0) {
					ok($_ eq "transfer-b9f7f302ecbe61d09776644e91a88de447b040f4c8e2bea0a1d22478da23e1fb","Test ExecutionResult transfer list first element value, Passed");
				} elsif($counter2 == 1) {
					ok($_ eq "transfer-32fccd3b5b737d5a2f0b969c1b8726e5c696146e55fcc5167f72a176b4959741","Test ExecutionResult transfer list first element value, Passed");					
				}
				$counter2 ++;
			}
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 120, "Test total Transform = 120, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteCLValue
				if($counter2 == 39) { # Test CasperTransform of type WriteCLValue
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "dictionary-49fc1c12a746ae792396b3b9d55db62719748b46ddda991e5907dbbb44d83a9a","Test 40th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 40th transform of type WriteAccount, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "060000000500e876481707200000002d1c7c43f92c48be88edf2bfa0f561f0f694f4a8d760b27cbc950140f12225932c0000004164336e527959354259635870433469307066577a7a34486b47753165384b4f2f4f72445a332b4b50636737","Test 40th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_ANY,"Test 40th transform of type WriteCLValue and CLValue clType of Any, Passed");
					ok($clValue->getParse()->getItsValueStr() eq $Common::ConstValues::NULL_VALUE,"Test 40th transform of type WriteCLValue and CLValue clParsed of Null, Passed");
				} elsif($counter2 == 41) { # Test CasperTransform of type WriteCLValue of cltype Map(String,String)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-a65f5728945bfcd619b286391d50b09873ce160c83914444b0467f6ceff729b8-000","Test 42th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 42th transform of type WriteAccount, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "0500000015000000636f6e74726163745f7061636b6167655f6861736840000000316543443066663331334431343044453766623743433743354632326339443736373435334463373037373732373264333645363530353362324665643837420a0000006576656e745f74797065070000006465706f736974090000007372635f7075727365560000005552656628643230343833353534453837623646324635394533314431624231383034413642653866364345624132623133646431363036333164366539633665393743352c20524541445f4144445f57524954452902000000746f4b0000004b65793a3a486173682864444537343732363339303538373137413432653232443239374436436633453037393036624235374263323845666345616333363737663841334463383362290500000076616c75650c000000313030303030303030303030","Test 42th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_MAP,"Test 42th transform of type WriteCLValue and CLValue clType of Any, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 42th transform of type WriteCLValue and CLValue clType of Any, Passed");
					ok($clValue->getCLType()->getInnerCLType2()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 42th transform of type WriteCLValue and CLValue clType of Any, Passed");
					my $parse = $clValue->getParse();
					my @listKey = $parse->getInnerParse1()->getItsValueList();
					my $totalKey = @listKey;
					ok($totalKey == 5, "Test total element of the Map parse = 5, Passed");
					my $counter3 = 0;
					foreach(@listKey) {
						print "\nList key number ".$counter3." is:".$_."\n";
						my $oneParse = $_;
						if($counter3 == 0) {
							ok($oneParse->getItsValueStr() eq "contract_package_hash", "Test 1st Map element key, Passed");
						} elsif($counter3 == 1) {
							ok($oneParse->getItsValueStr() eq "event_type", "Test 2nd Map element key, Passed");
						} elsif($counter3 == 2) {
							ok($oneParse->getItsValueStr() eq "src_purse", "Test 3rd Map element key, Passed");
						} elsif($counter3 == 3) {
							ok($oneParse->getItsValueStr() eq "to", "Test 4th Map element key, Passed");
						} elsif($counter3 == 4) {
							ok($oneParse->getItsValueStr() eq "value", "Test 5th Map element key, Passed");
						} 
						$counter3 ++;
					}
					$counter3 = 0;
					my @listValue = $parse->getInnerParse2()->getItsValueList();
					foreach(@listValue) {
						my $oneParse = $_;
						if($counter3 == 0) {
							ok($oneParse->getItsValueStr() eq "1eCD0ff313D140DE7fb7CC7C5F22c9D767453Dc70777272d36E65053b2Fed87B", "Test 1st Map element value, Passed");
						} elsif($counter3 == 1) {
							ok($oneParse->getItsValueStr() eq "deposit", "Test 2nd Map element value, Passed");
						} elsif($counter3 == 2) {
							ok($oneParse->getItsValueStr() eq "URef(d20483554E87b6F2F59E31D1bB1804A6Be8f6CEbA2b13dd160631d6e9c6e97C5, READ_ADD_WRITE)", "Test 3rd Map element value, Passed");
						} elsif($counter3 == 3) {
							ok($oneParse->getItsValueStr() eq "Key::Hash(dDE7472639058717A42e22D297D6Cf3E07906bB57Bc28EfcEac3677f8A3Dc83b)", "Test 4th Map element value, Passed");
						} elsif($counter3 == 4) {
							ok($oneParse->getItsValueStr() eq "100000000000", "Test 5th Map element value, Passed");
						} 
						$counter3 ++;
					}
				}
				$counter2 ++;
			}
		}
	}
}
# Test 11: information for deploy at this address: https://testnet.cspr.live/deploy/2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61
# Test the following CLType: Tuple2, Tuple3, Result
sub getDeploy11 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("2ad794272a1a805082f171f96f1ea0e71fcac3ae6dd0c525343199b553be8a61");
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
	my $counter2 = 0;
	foreach(@list) {
		if($counter1 == 0) {
			my $oneER = $_; #JsonExecutionResult object
			ok($oneER->getBlockHash() eq "a9f164ace58159786a060d5c14f70d8a6a5a7164e6b3650eff55f80c0ad59e9f", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "851555700", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 0, "Test ExecutionResult transfer list of 0 element, Passed");
			
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 47, "Test total Transform = 47, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteCLValue
				if($counter2 == 16) { # Test CasperTransform of type WriteCLValue with cltype of type Result(String,String)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-9eae5968006607cc910450d191dd2b83e93311a2200c4385cd9f47c2a0ff09f7-000","Test 17th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 17th transform of type WriteAccount, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "010a000000676f6f64726573756c74","Test 17th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT,"Test 17th transform of type WriteCLValue and CLValue clType of Result, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 17th transform of type WriteCLValue and CLValue clType of Result(String,String) - ok, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 17th transform of type WriteCLValue and CLValue clType of Result(String,String) - err, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "goodresult","Test 17th transform of type WriteCLValue and CLValue clParsed, Passed");
				} elsif($counter2 == 21) { # Test CasperTransform of type WriteCLValue with cltype of type Result(String,String)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-74a03aae2f907430a6f6654718b6c4bbdacc260c3bf1537f72a392f210ddf5e2-000","Test 22th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 22nd transform of type WriteAccount, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "0009000000626164726573756c74","Test 22nd transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT,"Test 22nd transform of type WriteCLValue and CLValue clType of Result, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 22nd transform of type WriteCLValue and CLValue clType of Result(String,String) - ok, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 22nd transform of type WriteCLValue and CLValue clType of Result(String,String) - err, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "badresult","Test 22nd transform of type WriteCLValue and CLValue clParsed, Passed");
				} 
				$counter2 ++;
			}
		}
	}
}
#getDeploy10();
getDeploy11();