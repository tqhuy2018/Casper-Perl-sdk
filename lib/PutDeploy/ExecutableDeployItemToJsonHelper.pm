# This class does the work of turning an ExecutableDeployItem object to Json String, used for account_put_deploy RPC call
package PutDeploy::ExecutableDeployItemToJsonHelper;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );
use CLValue::CLValue;
use GetDeploy::ExecutableDeployItem::NamedArg;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;
use Common::ConstValues;

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}
# This function does the work of turning an ExecutableDeployItem object to Json String, used for account_put_deploy RPC call
# input: an ExecutableDeployItem object
# output: The Json string that represents the ExecutableDeployItem object, used for account_put_deploy RPC call.
sub toJsonString {
	my @list = @_;
	my $executableDeployItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$executableDeployItem = $list[1];
	if($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_MODULE_BYTES) {
		my $ediMB = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes();
		$ediMB = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $ediMB->getArgs();
		my $argStr = argsToJsonString($ras);
		my $moduleBytes = $ediMB->getModuleBytes();
		my $innerJson = "{\"module_bytes\": \"".$moduleBytes."\",".$argStr."}";
		return "{\"ModuleBytes\": ".$innerJson."}";
	} elsif ($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_STORED_CONTRACT_BY_HASH) {
		my $ediBH = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash();
		$ediBH = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $ediBH->getArgs();
		my $argStr = argsToJsonString($ras);
		my $innerJson = "{\"hash\": \"".$ediBH->getItsHash()."\",\"entry_point\": \"". $ediBH->getEntryPoint()."\",".$argStr."}";
		return "{\"StoredContractByHash\": ".$innerJson."}";
	} elsif ($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_STORED_CONTRACT_BY_NAME) {
		my $ediBN = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName();
		$ediBN = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $ediBN->getArgs();
		my $argStr = argsToJsonString($ras);
		my $innerJson = "{\"name\": \"".$ediBN->getItsName()."\",\"entry_point\": \"". $ediBN->getEntryPoint()."\",".$argStr."}";
		return "{\"StoredContractByName\": ".$innerJson."}";
	} elsif ($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_NAME) {
		my $edi = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName();
		$edi = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $edi->getArgs();
		my $argStr = argsToJsonString($ras);
		my $innerJson = "";
		if ($edi->getVersion()) {
			$innerJson = "{\"name\": \"".$ediBN->getItsName()."\",\"version\":".$edi->getVersion().",\"entry_point\": \"". $ediBN->getEntryPoint()."\",".$argStr."}";
		} else {
			$innerJson = "{\"name\": \"".$ediBN->getItsName()."\",\"version\":null,\"entry_point\": \"". $ediBN->getEntryPoint()."\",".$argStr."}";
		}
		return "{\"StoredVersionedContractByName\": ".$innerJson."}";
	} elsif ($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_HASH) {
		my $edi = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash();
		$edi = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $edi->getArgs();
		my $argStr = argsToJsonString($ras);
		my $innerJson = "";
		if ($edi->getVersion()) {
			$innerJson = "{\"hash\": \"".$ediBN->getItsHash()."\",\"version\":".$edi->getVersion().",\"entry_point\": \"". $ediBN->getEntryPoint()."\",".$argStr."}";
		} else {
			$innerJson = "{\"hash\": \"".$ediBN->getItsHash()."\",\"version\":null,\"entry_point\": \"". $ediBN->getEntryPoint()."\",".$argStr."}";
		}
		return "{\"StoredVersionedContractByHash\": ".$innerJson."}";
		
	} elsif ($executableDeployItem->getItsType() eq $Common::ConstValues::EDI_TRANSFER) {
		my $edi = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
		$edi = $executableDeployItem->getItsValue();
		my $ras = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
		$ras = $edi->getArgs();
		my $argStr = argsToJsonString($ras);
		my $innerJson = "{".$argStr."}";
        return "{\"Transfer\": ".$innerJson."}";
	} else {
		return "";
	}
}
# This function does the work of turning an RuntimeArgs object to Json String, used for ExecutableDeployItemHelper.toJsonString function
# input: a RuntimeArgs object
# output: a Json String represents the RuntimeArgs object
sub argsToJsonString {
	my @list = @_;
	my $args = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	$args = $list[0];
	my @listNA = $args->getListNamedArg();
	my $totalArgs = @listNA;
	my $ret = "";
	my $counter = 0;
	if($totalArgs>0) {
		my @sequence = (0..$totalArgs-1);
		for my $i (@sequence) {
			my $oneNA = new GetDeploy::ExecutableDeployItem::NamedArg();
			$oneNA = $listNA[$i];
			my $clValue = new CLValue::CLValue();
			$clValue = $oneNA->getCLValue();
			my $clValueJsonStr = $clValue->toJsonString();
			my $argStr = "[\"".$oneNA->getItsName()."\",".$clValueJsonStr."]";
			if($counter < $totalArgs-1) {
				$ret = $ret.$argStr.",";
			} else {
				$ret = $ret.$argStr;
			}
			$counter ++;
		}
		$ret = "\"args\": [".$ret."]";
		return $ret;
	} else {
		return "\"args\":[]";
	}
}
1;