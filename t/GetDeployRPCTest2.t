#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 151;

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
				# assertion for Transform of type WriteCLValue - Result(Ok)
				if($counter2 == 16) { # Test CasperTransform of type WriteCLValue with cltype of type Result(String,String)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-9eae5968006607cc910450d191dd2b83e93311a2200c4385cd9f47c2a0ff09f7-000","Test 17th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 17th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "010a000000676f6f64726573756c74","Test 17th transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT,"Test 17th transform of type WriteCLValue and CLValue clType of Result, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 17th transform of type WriteCLValue and CLValue clType of Result(String,String) - ok, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 17th transform of type WriteCLValue and CLValue clType of Result(String,String) - err, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "Ok","Test 17th transform of type WriteCLValue and CLValue clParsed of type Result Ok, Passed");
					ok($clValue->getParse()->getInnerParse1()->getItsValueStr() eq "goodresult","Test 17th transform of type WriteCLValue and CLValue clParsed, Passed");
				} # assertion for Transform of type WriteCLValue - Result(Err) 
				elsif($counter2 == 21) { # Test CasperTransform of type WriteCLValue with cltype of type Result(String,String)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-74a03aae2f907430a6f6654718b6c4bbdacc260c3bf1537f72a392f210ddf5e2-000","Test 22th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 22nd transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "0009000000626164726573756c74","Test 22nd transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_RESULT,"Test 22nd transform of type WriteCLValue and CLValue clType of Result, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 22nd transform of type WriteCLValue and CLValue clType of Result(String,String) - ok, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 22nd transform of type WriteCLValue and CLValue clType of Result(String,String) - err, Passed");
					ok($clValue->getParse()->getItsValueStr() eq "Err","Test 22nd transform of type WriteCLValue and CLValue clParsed of type Result Err, Passed");
					ok($clValue->getParse()->getInnerParse1()->getItsValueStr() eq "badresult","Test 22nd transform of type WriteCLValue and CLValue clParsed, Passed");
				} # assertion for Transform of type WriteCLValue - Tuple2 (String, U512)
				elsif($counter2 == 31) { # Test CasperTransform of type WriteCLValue with cltype of type Tuple2(String,U512)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-75789066d17abd5a2629c3f5b82af2827c2098edde6868356ea5114d7d6fa86d-000","Test 32th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue - Tuple2 (String, U512)
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 32nd transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "030000006162630101","Test 32nd transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_TUPLE2,"Test 32nd transform of type WriteCLValue and CLValue clType of Tuple2, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 32nd transform of type WriteCLValue and CLValue clType of Tuple2(String,U512) - String, Passed");
					ok($clValue->getCLType()->getInnerCLType2()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U512,"Test 32nd transform of type WriteCLValue and CLValue clType of Result(String,U512) - U512, Passed");
					my $parse = $clValue->getParse();
					ok($parse->getInnerParse1()->getItsValueStr() eq "abc","Test 32nd transform of type WriteCLValue and CLValue clParsed String value = abc, Passed");
					ok($parse->getInnerParse2()->getItsValueStr() eq "1","Test 32nd transform of type WriteCLValue and CLValue clParsed U512 value = 1, Passed");
				} # assertion for Transform of type WriteCLValue - Tuple3 (PublicKey, Option(String),U512)
				elsif($counter2 == 36) { # Test CasperTransform of type WriteCLValue with cltype of type - Tuple3 (PublicKey, Option(String),U512)
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "uref-e8c07b8ebbd0e7af43283a767975d5d82a334cd92b339eba5c1a1a7ba0137a27-000","Test 37th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type  WriteCLValue - Tuple3 (PublicKey, Option(String),U512)
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CLVALUE,"Test 37th transform of type WriteCLValue, Passed");
					my $clValue = $oneT->getItsValue();
					ok($clValue->getBytes() eq "01a018bf278f32fdb7b06226071ce399713ace78a28d43a346055060a660ba7aa901030000006162630102","Test 32nd transform of type WriteCLValue and CLValue bytes, Passed");
					ok($clValue->getCLType()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_TUPLE3,"Test 37th transform of type WriteCLValue and CLValue clType of Tuple2, Passed");
					ok($clValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_PUBLICKEY,"Test 37th transform of type WriteCLValue and CLValue clType of PublicKey, Passed");
					ok($clValue->getCLType()->getInnerCLType2()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_OPTION,"Test 37th transform of type WriteCLValue and CLValue clType of Option, Passed");
					ok($clValue->getCLType()->getInnerCLType2()->getInnerCLType1()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_STRING,"Test 37th transform of type WriteCLValue and CLValue clType of Option(String), Passed");
					ok($clValue->getCLType()->getInnerCLType3()->getItsTypeStr() eq $Common::ConstValues::CLTYPE_U512,"Test 37th transform of type WriteCLValue and CLValue clType of U512, Passed");
					my $parse = $clValue->getParse();
					ok($parse->getInnerParse1()->getItsValueStr() eq "01a018bf278f32fdb7b06226071ce399713ace78a28d43a346055060a660ba7aa9","Test 37th transform of type WriteCLValue and CLValue clParsed PublicKey value = 01a018bf278f32fdb7b06226071ce399713ace78a28d43a346055060a660ba7aa9, Passed");
					ok($parse->getInnerParse2()->getItsValueStr() eq "abc","Test 37th transform of type WriteCLValue and CLValue clParsed Option(String) value = abc, Passed");
					ok($parse->getInnerParse3()->getItsValueStr() eq "2","Test 37th transform of type WriteCLValue and CLValue clParsed Option(String) value = 2, Passed");
				} 
				$counter2 ++;
			}
		}
	}
}

# Test 12: information for deploy at this address: https://testnet.cspr.live/deploy/091bd25de1769c0df180fed8c67a396c7e4373639b4a8469e26a605f92e72df0
# Test the following Transform type: WriteContractWasm, WriteContract, WriteContractPackage
sub getDeploy12 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("091bd25de1769c0df180fed8c67a396c7e4373639b4a8469e26a605f92e72df0");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	$getDeployRPC->setUrl($Common::ConstValues::TEST_NET);
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
			ok($oneER->getBlockHash() eq "598bd01dff7abaebd1f60c9d8c8fc66de6bdd9a44db4570701de4939fade1991", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "113320088290", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 0, "Test ExecutionResult transfer list of 0 element, Passed");
			
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 24, "Test total Transform = 24, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteContractPackage 
				if($counter2 == 9) { # Test CasperTransform of type WriteContractPackage 
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "hash-996d8ef48d767a83b8098acbfbbd25cc56a6194807af6e94f190d672c0b1ee23","Test 10th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteContractPackage
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CONTRACT_PACKAGE,"Test 10th transform of type WriteContractPackage, Passed");
				} # assertion for Transform of type WriteContractWasm  
				elsif($counter2 == 11) { # Test CasperTransform of type WriteContractWasm 
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "hash-98c2fd452242526d4c53366705f169812a4cc5b2ee89bf63c6fb28f3c5a3f503","Test 12th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteContractWasm
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CONTRACT_WASM,"Test 12th transform of type WriteContractWasm, Passed");
				} elsif($counter2 == 12) { # Test CasperTransform of type WriteContract 
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "hash-5bfb3233216d08490ab74ddd04b0ff7df3450a63d15976efcf57facd2ebaf5bf","Test 13th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteContractWasm
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_CONTRACT,"Test 13th transform of type WriteContractWasm, Passed");
				}
				$counter2 ++;
			}
		}
	}
}

# Test 13: information for deploy at this address: https://testnet.cspr.live/deploy/091bd25de1769c0df180fed8c67a396c7e4373639b4a8469e26a605f92e72df0
# Test the following Transform type: WriteBid, WriteWithdraw
sub getDeploy13 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("acb4d78cbb900fe91a896ea8a427374c5d600cd9206efae2051863316265f1b1");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	$getDeployRPC->setUrl($Common::ConstValues::MAIN_NET);
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
			ok($oneER->getBlockHash() eq "2172e2f922e05186c5f21eabbbf32206afd263c3fcaf490a95d81c706f4a8a92", "Test JsonExecutionResult block hash, Passed" );
			my $result = $oneER->getResult();
			# assertion for ExecutionResult
			ok($result->getItsType() eq "Success", "Test ExecutionResult of type Success, Passed");
			ok($result->getCost() eq "10000", "Test ExecutionResult cost, Passed");
			# assertion for Transfers
			my @listTransfer = $result->getTransfers();
			my $totalTransfer = @listTransfer;
			ok($totalTransfer == 0, "Test ExecutionResult transfer list of 0 element, Passed");
			
			my $effect = $result->getEffect();
			my @transform = $effect->getTransforms();
			my @operations = $effect->getOperations();
			my $totalOperations = @operations;
			my $totalTransform = @transform;
			ok($totalTransform == 24, "Test total Transform = 24, Passed");
			ok($totalOperations == 0, "Test total Operations = 0, Passed");
			my $counter2 = 0;
			foreach(@transform) {
				# assertion for Transform of type WriteWithdraw 
				if($counter2 == 12) { # Test CasperTransform of type WriteWithdraw 
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "withdraw-24b6d5aabb8f0ac17d272763a405e9ceca9166b75b745cf200695e172857c2dd","Test 13th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteContractPackage
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_WITHDRAW,"Test 13th transform of type WriteWithdraw, Passed");
					my $withdraw = $oneT->getItsValue();
					my @listUP = $withdraw->getListUnbondingPurse();
					my $totalUP = @listUP;
					ok($totalUP == 7, "Test total UnbondingPurse, Passed");
					my $counter3 = 0;
					foreach(@listUP) {
						# assertion for the first UnbondingPurse
						if($counter3 == 0) {
							my $oneUP = $_;
							ok($oneUP->getBondingPurse() eq "uref-fd78a335a6b3e86b0a0161ac7640a69ec858c32f0d549dc5c3ba820a5bd13616-007", "Test first UnbondingPurse bonding_purse, Passed ");
							ok($oneUP->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b", "Test first UnbondingPurse validator_public_key, Passed ");
							ok($oneUP->getUnbonderPublicKey() eq "02033444b5a5584d8bb3427fc8fdbd306e8a9a7cf66570acb461a80a186fe1566fdd", "Test first UnbondingPurse unbonder_public_key, Passed ");
							ok($oneUP->getEraOfCreation() eq "3475", "Test first UnbondingPurse era_of_creation, Passed ");
							ok($oneUP->getAmount() eq "100131800754797", "Test first UnbondingPurse amount, Passed ");
						}
						# assertion for the second UnbondingPurse
						if($counter3 == 1) {
							my $oneUP = $_;
							ok($oneUP->getBondingPurse() eq "uref-ddb8c8e6503deba1b3f3558b23978c9bcabc8f06eead4246c9cedbe9dc8634ca-007", "Test first UnbondingPurse bonding_purse, Passed ");
							ok($oneUP->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b", "Test first UnbondingPurse validator_public_key, Passed ");
							ok($oneUP->getUnbonderPublicKey() eq "020232529838de2d2036618c9da058ca5955fe9ac2702a3d09ea9084670196462198", "Test first UnbondingPurse unbonder_public_key, Passed ");
							ok($oneUP->getEraOfCreation() eq "3476", "Test first UnbondingPurse era_of_creation, Passed ");
							ok($oneUP->getAmount() eq "319709717548988", "Test first UnbondingPurse amount, Passed ");
						}
						$counter3 ++;
					}
				} # assertion for Transform of type WriteWithdraw  
				elsif($counter2 == 14) { # Test CasperTransform of type WriteBid 
					my $oneTE = $_; # TransformEntry
					ok($oneTE->getKey() eq "bid-24b6d5aabb8f0ac17d272763a405e9ceca9166b75b745cf200695e172857c2dd","Test 15th TransformEntry key value, Passed");
					my $oneT = $oneTE->getTransform(); # CasperTransform of type WriteBid
					ok($oneT->getItsType() eq $Common::ConstValues::TRANSFORM_WRITE_BID,"Test 15th transform of type WriteBid, Passed");
					my $bid = $oneT->getItsValue();
					ok($bid->getInactive() == 0, "Test bid inactive = false, Passed");
					ok($bid->getBondingPurse() eq "uref-9ef6b11bd095c1733956e3b7e5bb47630f5fa59ad9a89c87fa671a1177e0c025-007", "Test bid bonding_purse, Passed");
					ok($bid->getDelegationRate() eq "10", "Test bid delegation_rate, Passed");
					ok($bid->getStakedAmount() eq "369103604862659", "Test bid staked_amount, Passed");
					ok($bid->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b", "Test bid validator_publickey, Passed");
					my @delegatorList = $bid->getDelegators();
					my $totalDelegator = @delegatorList;
					ok($totalDelegator == 3181, "Test total delegator = 3181, Passed");
					my $counter3 = 0;
					foreach(@delegatorList) {
						if($counter3 == 95) {
							my $oneD = $_;
							ok($oneD->getPublicKey() eq "010a6eb8216afcaa59f9202d8bb12e30caf0c46f6c0da08ced34471d80cdfde650", "Test 95th delegator public key value, Passed");
							ok($oneD->getBondingPurse() eq "uref-bac31707e7a39743d653c93a1b664b0be3546a336387cee282183be50239ec42-007", "Test 95th delegator bonding_purse value, Passed");
							ok($oneD->getStakedAmount() eq "9000875653986624", "Test 95th delegator staked_amount value, Passed");
							ok($oneD->getValidatorPublicKey() eq "012bac1d0ff9240ff0b7b06d555815640497861619ca12583ddef434885416e69b", "Test 95th validator public key value, Passed");
							ok($oneD->getDelegatorPublicKey() eq "010a6eb8216afcaa59f9202d8bb12e30caf0c46f6c0da08ced34471d80cdfde650", "Test 95th delegator public key value, Passed");
							my $vs = $oneD->getVestingSchedule();
							ok($vs->getInitialReleaseTimestampMillis() eq "1624978800000", "Test vesting schedule initialReleaseTimestampMillis value, Passed");
							my @listLA = $vs->getLockedAmounts();
							my $totalLA = @listLA;
							ok($totalLA == 14, "Test total LockedAmount in VestingSchedule of Delegator = 14, Passed");
							my $counter4 = 0;
							foreach(@listLA) {
								if($counter4 == 0) {
									print("\nFirst locked amount:".$_."\n");
									ok($_ eq "7895222924551040", "Test first LockedAmount value, Passed");
								}
								elsif($counter4 == 1) {
									print("\nSecond locked amount:".$_."\n");
									ok($_ eq "7287898084200960", "Test second LockedAmount value, Passed");
								}
								$counter4 ++;
							}
						}
						$counter3 ++;
					}
				} 
				$counter2 ++;
			}
		}
	}
}

# Negative path, get Deploy with wrong Deploy hash
sub getDeploy14 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("AAA");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $error = $getDeployRPC->getDeployResult($paramStr);
	ok($error->getErrorCode() eq "-32602", "Test error when send wrong deploy hash, error is thrown, error code checked, Passed");
	ok($error->getErrorMessage() eq "Invalid params", "Test error when send wrong deploy hash, error is thrown, error message checked, Passed");
}
# Negative path, get Deploy with no Deploy hash
sub getDeploy15 {
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $error = $getDeployRPC->getDeployResult($paramStr);
	ok($error->getErrorCode() eq "-32602", "Test error when send wrong deploy hash, error is thrown, error code checked, Passed");
	ok($error->getErrorMessage() eq "Invalid params", "Test error when send wrong deploy hash, error is thrown, error message checked, Passed");
}
getDeploy10();
getDeploy11();
getDeploy12();
getDeploy13();
getDeploy14();
getDeploy15();