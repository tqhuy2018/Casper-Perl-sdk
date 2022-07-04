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
	}
}
# This function does the work of turning an RuntimeArgs object to Json String, used for ExecutableDeployItemHelper.toJsonString function
sub argsToJsonString {
	my @list = @_;
	my $args = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	$args = @list[0];
	my @listNA = $args->getListNamedArg();
	my $totalArgs = @listNA;
	my $ret = "";
	my $counter = 0;
	if($totalArgs>0) {
		my @sequence = (0..$totalArgs-1);
		for my $i (@sequence) {
			my $oneNA = new GetDeploy::ExecutableDeployItem::NamedArg();
			$oneNA = @listNA[$i];
			my $clValue = new CLValue::CLValue();
			$clValue = $oneNA->getCLValue();
			my $clValueJsonStr = $clValue->toJsonString();
			my $argStr = "[\"".$oneNA->getItsName()."\",".$clValueJsonStr."]";
			if($counter < $totalArgs) {
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