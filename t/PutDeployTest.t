#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 6;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Time::HiRes qw(time);
use POSIX qw(strftime);

use Serialization::CLParseSerialization;
use CLValue::CLType;
use CLValue::CLParse;
use CLValue::CLValue;
use Common::ConstValues;
use GetDeploy::Deploy;
use GetDeploy::DeployHeader;
use GetDeploy::ExecutableDeployItem::NamedArg;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;
# test put deploy with input isEd25519 = int, 1 then use Ed25519 account, 0 then use Secp256k1 account
sub testPutDeploy {
	my @list = @_;
	my $isEd25519 = int($list[0]);
	my $accountEd25519 = "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4";
	my $accountSecp256k1 = "0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499";
	my $deploy = new GetDeploy::Deploy();
	my $deployHeader = new GetDeploy::DeployHeader();
	if ($isEd25519 == 1) {
		$deployHeader->setAccount($accountEd25519);
	} else {
		$deployHeader->setAccount($accountSecp256k1);
	}
	# get current time to assign the timestamp value
	my $t = time;
	my $date = strftime "%Y-%m-%dT%H:%M:%S", localtime $t;
	$date .= sprintf ".%03d", ($t-int($t))*1000;
	$date = $date."Z";
	print $date, "\n";
	$date = "2022-06-14T09:58:16.223Z";
	$deployHeader->setTimestamp($date);
	$deployHeader->setChainName("casper-test");
	$deployHeader->setTTL("1h 30m");
	$deployHeader->setGasPrice(1);
	# Deploy payment initialization
	my $clValue = new CLValue::CLValue();
	$clValue->setBytes("0400ca9a3b");
	my $clType = new CLValue::CLType();
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	my $clParse = new CLValue::CLParse();
	$clParse->setItsCLType($clType);
	$clParse->setItsValueStr("1000000000");
	$clValue->setCLType($clType);
	$clValue->setParse($clParse);
	my $namedArg = new GetDeploy::ExecutableDeployItem::NamedArg();
	$namedArg->setItsName("amount");
	$namedArg->setCLValue($clValue);
	my $runTimeArgs = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listArgs = ($nameArg);
	$runTimeArgs->setListNamedArg(@listArgs);
	
	my $payment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$payment->setItsType($Common::ConstValues::EDI_MODULE_BYTES);
}
testPutDeploy(1);