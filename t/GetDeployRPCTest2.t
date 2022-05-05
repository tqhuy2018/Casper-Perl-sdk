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

# Test 7: information for deploy at this address: https://testnet.cspr.live/deploy/0fe0adccf645e99b9b58493c843516cd354b189e1c3efe62c4f2768716a41932
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
	ok($session->getItsType() eq "ModuleBytes", "Test deploy session of type ModuleBytes - Passed");
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
			ok($oneNASession->getItsName() eq "deployment_thereshold", "Test session 6th arg name - Passed");
			my $sessionArgCLValue = $oneNASession->getCLValue();
			ok($sessionArgCLValue->getBytes() eq "02","Test session 6th arg CLValue, bytes value  - Passed");
			ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq $Common::ConstValue::CLTYPE_UREF,"Test session 6th arg CLValue, cl_type  - Passed");
			ok($sessionArgCLValue->getParse()->getItsValueStr() eq "2","Test session 6th arg CLValue, parse - Passed");
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
getDeploy10();