=comment
Class built for storing StoredValue information.
This class has two atrributes: _itsType and _itsValue
The StoredValue can be 1 among 10 possible values as described in this link: 
https://docs.rs/casper-node/latest/casper_node/types/json_compatibility/enum.StoredValue.html
In detail, the value can be 1 among these values:
 	CLValue(CLValue),
    Account(Account),
    ContractWasm(String),
    Contract(Contract),
    ContractPackage(ContractPackage),
    Transfer(Transfer),
    DeployInfo(DeployInfo),
    EraInfo(EraInfo),
    Bid(Box<Bid>),
    Withdraw(Vec<UnbondingPurse>),
This class has 2 attributes: _itsType and _itsValue
The attribute _itsType hold the type of 1 among 10 possible type above, in String format
The attribute _itsValue hold the value of the stored value
For example if the StoredValue is 
CLValue(bytes":"0400e1f505"
"parsed":"100000000"
"cl_type":"U512"
)
To store information of such StoredValue, the following work will be called:
1) Instantiate a StoredValue object and set _itsType to "CLValue":
my $storedValue = new StoredValue::StoredValue();
$storedValue->setItsType("CLValue");
2) Instantiate one CLValue:CLValue object and set this properties like this:
my $clValue = new CLValue::CLValue();
$clValue->setBytes("0400e1f505");
my $clType = new CLValue::CLType();
$clType->setItsTypeStr("U512");
$clValue->setCLType($clType);
my $clParse = new CLValue::CLParse();
$clParse->setItsValueStr("100000000");
$clValue->setParse($clParse);
3) Assign the _itsValue of the $storedValue object to the $clValue
$storedValue->setItsValue($clValue);
=cut 
package StoredValue::StoredValue;
use CLValue::CLValue;
use Common::ConstValues;
use GetDeploy::ExecutionResult::Transform::CasperTransfer;
use StoredValue::CasperContract;
use GetDeploy::ExecutionResult::Transform::DeployInfo;
use GetDeploy::ExecutionResult::Transform::EraInfo;
use GetDeploy::ExecutionResult::Transform::Bid;
use GetDeploy::ExecutionResult::Transform::Withdraw;
use StoredValue::Account;
sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsType
sub setItsType {
	my ( $self, $value) = @_;
	$self->{_itsType} = $value if defined($value);
	return $self->{_itsType};
}

sub getItsType {
	my ( $self ) = @_;
	return $self->{_itsType};
}

# get-set method for _itsValue
sub setItsValue {
	my ( $self, $value) = @_;
	$self->{_itsValue} = $value if defined($value);
	return $self->{_itsValue};
}

sub getItsValue {
	my ( $self ) = @_;
	return $self->{_itsValue};
}

# This function parse the JsonObject (taken from server RPC method call) to get the StoredValue object
sub fromJsonObjectToStoredValue {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::StoredValue();
	# 1. Get StoredValue of type CLValue
	my $clValueJson = $json->{$Common::ConstValues::STORED_VALUE_CLVALUE};
	if($clValueJson) {
		my $clValue = CLValue::CLValue->fromJsonObjToCLValue($clValueJson);
		$ret->setItsValue($clValue);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_CLVALUE);
		return $ret;
	}
	# 2. Get StoredValue of type Account
	my $accountJson = $json->{$Common::ConstValues::STORED_VALUE_ACCOUNT};
	if($accountJson) {
		my $account =  StoredValue::Account->fromJsonObjectToAccount($accountJson);
		$ret->setItsValue($account);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_ACCOUNT);
		return $ret;
	}
	# 3. Get StoredValue of type ContractWasm
	my $contractWasmJson = $json->{$Common::ConstValues::STORED_VALUE_CONTRACT_WASM};
	if($contractWasmJson) {
		$ret->setItsValue($contractWasmJson);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_CONTRACT_WASM);
		return $ret;
	}
	# 4. Get StoredValue of type Contract
	my $storeValueContractJson = $json->{$Common::ConstValues::STORED_VALUE_CONTRACT};
	if($storeValueContractJson) {
		my $contract = StoredValue::CasperContract->fromJsonObjectToCasperContract($storeValueContractJson);
		$ret->setItsValue($contract);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_CONTRACT);
		return $ret;
	}
	# 5. Get StoredValue of type ContractPackage
	my $storeValueContractPackage = $json->{$Common::ConstValues::STORED_VALUE_CONTRACT_PACKAGE};
	if($storeValueContractPackage) {
		my $contractPackage = StoredValue::ContractPackage->fromJsonObjectToContractPackage($storeValueContractPackage);
		$ret->setItsValue($contractPackage);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_CONTRACT_PACKAGE);
		return $ret;
	}
	# 6. Get StoredValue of type Transfer
	my $storedValueTransfer = $json->{$Common::ConstValues::STORED_VALUE_TRANSFER};
	if($storedValueTransfer) {
		my $transfer = GetDeploy::ExecutionResult::Transform::CasperTransfer->fromJsonToTransfer($storedValueTransfer);
		$ret->setItsValue($transfer);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_TRANSFER);
		return $ret;
	}
	# 7. Get StoredValue of type DeployInfo
	my $storedValueDeployInfo = $json->{$Common::ConstValues::STORED_VALUE_DEPLOY_INFO};
	if($storedValueDeployInfo) {
		my $deployInfo = GetDeploy::ExecutionResult::Transform::DeployInfo->fromJsonToDeployInfo($storedValueDeployInfo);
		$ret->setItsValue($deployInfo);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_DEPLOY_INFO);
		return $ret;
	}
	# 8. Get StoredValue of type EraInfo
	my $storedValueEraInfo = $json->{$Common::ConstValues::STORED_VALUE_ERA_INFO};
	if($storedValueEraInfo) {
		my $eraInfo = GetDeploy::ExecutionResult::Transform::EraInfo->fromJsonObjectToEraInfo($storedValueEraInfo);
		$ret->setItsValue($eraInfo);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_ERA_INFO);
		return $ret;
	}
	# 9. Get StoredValue of type Bid
	my $storedValueBid = $json->{$Common::ConstValues::STORED_VALUE_BID};
	if($storedValueBid) {
		my $bid = GetDeploy::ExecutionResult::Transform::Bid->fromJsonToBid($storedValueBid);
		$ret->setItsValue($bid);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_BID);
		return $ret;
	}
	# 10. Get StoredValue of type Withdraw
	my $storedValueWithdraw = $json->{$Common::ConstValues::STORED_VALUE_WITHDRAW};
	if($storedValueWithdraw) {
		my @listWithdrawJson = @{$storedValueWithdraw};
		my $withdraw = GetDeploy::ExecutionResult::Transform::Withdraw->fromJsonArrayToWithdraw($storedValueWithdraw);
		$ret->setItsValue($withdraw);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_WITHDRAW);
		return $ret;
	}
	return $ret;
}
1;