# Class built for storing TransformEntry information
# and handles the change from Json object to TransformEntry object
package GetDeploy::ExecutionResult::TransformEntry;
use GetDeploy::ExecutionResult::CasperTransform;
use GetDeploy::ExecutionResult::Transform::CasperTransfer;
use GetDeploy::ExecutionResult::Transform::NamedKey;
use GetDeploy::ExecutionResult::Transform::DeployInfo;
use GetDeploy::ExecutionResult::Transform::Withdraw;
use GetDeploy::ExecutionResult::Transform::Bid;
use Common::ConstValues;
sub new {
	my $class = shift;
	my $self = {
		_key => shift,
		_transform => shift, # CasperTransform object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _key
sub setKey {
	my ( $self, $key) = @_;
	$self->{_key} = $key if defined($key);
	return $self->{_key};
}

sub getKey {
	my ( $self ) = @_;
	return $self->{_key};
}

# get-set method for _transform
sub setTransform {
	my ( $self, $transform) = @_;
	$self->{_transform} = $transform if defined($transform);
	return $self->{_transform};
}

sub getTransform {
	my ( $self ) = @_;
	return $self->{_transform};
}

# This function parse the JsonObject (taken from server RPC method call) to get the TransformEntry object
sub fromJsonToCasperTransform {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::TransformEntry();
	$ret->setKey($json->{'key'});
	my $transformJson = $json->{'transform'};
	my $transform = new GetDeploy::ExecutionResult::CasperTransform();
	if ($transformJson eq "Identity") {
		$transform->setItsType("Identity");
	} elsif ($transformJson eq "WriteContractWasm") {
		$transform->setItsType("WriteContractWasm");
	} elsif ($transformJson eq "WriteContract") {
		$transform->setItsType("WriteContract");
	} elsif ($transformJson eq "WriteContractPackage") {
		$transform->setItsType("WriteContractPackage");
	} elsif ($transformJson->{'AddInt32'}) {
		$transform->setItsType("AddInt32");
		$transform->setItsValue($transformJson->{'AddInt32'});
	} elsif ($transformJson->{'AddUInt64'}) {
		$transform->setItsType("AddUInt64");
		$transform->setItsValue($transformJson->{'AddUInt64'});
	} elsif ($transformJson->{'AddUInt128'}) {
		$transform->setItsType("AddUInt128");
		$transform->setItsValue($transformJson->{'AddUInt128'});
	} elsif ($transformJson->{'AddUInt256'}) {
		$transform->setItsType("AddUInt256");
		$transform->setItsValue($transformJson->{'AddUInt256'});
	} elsif ($transformJson->{'AddUInt512'}) {
		$transform->setItsType("AddUInt512");
		$transform->setItsValue($transformJson->{'AddUInt512'});
	} elsif ($transformJson->{'Failure'}) {
		$transform->setItsType("Failure");
		$transform->setItsValue($transformJson->{'Failure'});
	}  elsif ($transformJson->{'WriteAccount'}) {
		$transform->setItsType("WriteAccount");
		$transform->setItsValue($transformJson->{'WriteAccount'});
	} elsif ($transformJson->{'WriteCLValue'}) {
		$transform->setItsType("WriteCLValue");
		my $clValueJson = $transformJson->{'WriteCLValue'};
		$transform->setItsValue($transformJson->{'WriteCLValue'});
		my $bytes = $clValueJson->{'bytes'};
		my $clType = CLValue::CLType->getCLType($clValueJson->{'cl_type'});
   		my $clParse = CLValue::CLParse->getCLParsed($clValueJson->{'parsed'},$clType);
   		my $clValue = new CLValue::CLValue();
   		$clValue->setBytes($bytes);
   		$clValue->setCLType($clType);
   		$clValue->setParse($clParse);
		$transform->setItsValue($clValue);
	} elsif ($transformJson->{'AddKeys'}) {
		$transform->setItsType("AddKeys");
		my @listNamedKeyJson = @{$transformJson->{'AddKeys'}};
		my @list = ();
		foreach(@listNamedKeyJson) {
			my $oneNameKeyJson = $_;
			my $namedKey = GetDeploy::ExecutionResult::Transform::NamedKey->fromJsonObjectToNamedKey($oneNameKeyJson);
			push(@list,$nameKey);
		}
		$transform->setItsListValue(@list);
	} elsif($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_DEPLOY_INFO}) {
		$transform->setItsType($Common::ConstValues::TRANSFORM_WRITE_DEPLOY_INFO);
		my $deployInfo = GetDeploy::ExecutionResult::Transform::DeployInfo->fromJsonToDeployInfo($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_DEPLOY_INFO});
		$transform->setItsValue($deployInfo);
	} elsif($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_TRANSFER}) {
		$transform->setItsType($Common::ConstValues::TRANSFORM_WRITE_TRANSFER);
		my $casperTransfer = GetDeploy::ExecutionResult::Transform::CasperTransfer->fromJsonToTransfer($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_TRANSFER});
		$transform->setItsValue($casperTransfer);
	} elsif($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_WITHDRAW}) {
		$transform->setItsType($Common::ConstValues::TRANSFORM_WRITE_WITHDRAW);
		my $withdraw = GetDeploy::ExecutionResult::Transform::Withdraw->fromJsonArrayToWithdraw($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_WITHDRAW});
		$transform->setItsValue($withdraw);
	} elsif($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_BID}) {
		$transform->setItsType($Common::ConstValues::TRANSFORM_WRITE_BID);
		my $bid = GetDeploy::ExecutionResult::Transform::Bid->fromJsonToBid($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_BID});
		$transform->setItsValue($bid);
	} elsif($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_ERA_INFO}) {
		$transform->setItsType($Common::ConstValues::TRANSFORM_WRITE_ERA_INFO);
		my $eraInfo = GetDeploy::ExecutionResult::Transform::EraInfo->fromJsonObjectToEraInfo($transformJson->{$Common::ConstValues::TRANSFORM_WRITE_ERA_INFO});
		$transform->setItsValue($eraInfo);
	}
	$ret->setTransform($transform);
	return $ret;
}
1;