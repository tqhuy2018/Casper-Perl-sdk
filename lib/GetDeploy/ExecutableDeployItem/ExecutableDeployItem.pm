=comment
Class built for storing ExecutableDeployItem enum in general
 * This class has 2 attributes:
 * 1) itsType is for the type of the ExecutableDeployItem enum, which can be a string among these values:
 * ModuleBytes, StoredContractByHash, StoredContractByName, StoredVersionedContractByHash, StoredVersionedContractByName, Transfer
 * 2) itsValue: is and array of 1 element,
 * To hold the real ExecutableDeployItem enum value, which can be 1 among the following class
 * ExecutableDeployItem_ModuleBytes
 * ExecutableDeployItem_StoredContractByHash
 * ExecutableDeployItem_StoredContractByName
 * ExecutableDeployItem_StoredVersionedContractByHash
 * ExecutableDeployItem_StoredVersionedContractByName
 * ExecutableDeployItem_Transfer
 * This class also provides helper method to change from Json object to corresponding ExecutableDeployItem object.
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem;

use JSON;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName;
use Common::ConstValues;
sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless  $self, $class;
	return $self;
}

# get-set method for itsType
sub setItsType {
	my ($self,$itsType) = @_;
	$self->{_itsType} = $itsType if defined ($itsType);
	return $self->{_itsType};
}
sub getItsType {
	my ($self) = @_;
	return $self->{_itsType};
}

# get-set method for itsValue
sub setItsValue {
	my ($self,$itsValue) = @_;
	$self->{_itsValue} = $itsValue if defined($itsValue);
	return $self->{_itsValue};
}

sub getItsValue {
	my ($self) = @_;
	return $self->{_itsValue};
}

# This function turn a Json object to an ExecutableDeployItem object
sub fromJsonToExecutableDeployItem {
	my @list = @_;
    my $json = $list[1];
    my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
    # get ExecutableDeployItem of type ModuleBytes
    my $ediMBJson = $json->{$Common::ConstValues::EDI_MODULE_BYTES};
    if($ediMBJson) {
    	my $ediMB = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes->fromJsonObjectToEDIModuleBytes($ediMBJson);
    	$ret->setItsValue($ediMB);
    	$ret->setItsType($Common::ConstValues::EDI_MODULE_BYTES);
    }
    # get ExecutableDeployItem of type StoredContractByHash
    my $ediHashJson = $json->{$Common::ConstValues::EDI_STORED_CONTRACT_BY_HASH};
    if($ediHashJson) {
    	my $ediHash = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash->fromJsonObjectToEDIStoredContractByHash($ediHashJson);
    	$ret->setItsValue($ediHash);
    	$ret->setItsType($Common::ConstValues::EDI_STORED_CONTRACT_BY_HASH);
    }
    # get ExecutableDeployItem of type StoredContractByName
    my $ediNameJson = $json->{$Common::ConstValues::EDI_STORED_CONTRACT_BY_NAME};
    if($ediNameJson) {
    	my $ediName = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName->fromJsonObjectToEDIStoredContractByName($ediNameJson);
    	$ret->setItsValue($ediName);
    	$ret->setItsType($Common::ConstValues::EDI_STORED_CONTRACT_BY_NAME);
    }
    # get ExecutableDeployItem of type StoredVersionedContractByName
    my $ediVersionedNameJson = $json->{$Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_NAME};
    if($ediVersionedNameJson) {
    	my $ediVName = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName->fromJsonObjectToEDIStoredContractVersionedByName($ediVersionedNameJson);
    	$ret->setItsValue($ediVName);
    	$ret->setItsType($Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_NAME);
    }
    # get ExecutableDeployItem of type StoredVersionedContractByHash
    my $ediVersionedHashJson = $json->{$Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_HASH};
    if($ediVersionedHashJson) {
    	my $ediVHash = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash->fromJsonObjectToEDIStoredContractVersionedByHash($ediVersionedHashJson);
    	$ret->setItsValue($ediVHash);
    	$ret->setItsType($Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_HASH);
    }
    # get ExecutableDeployItem of type Transfer    
    my $ediTransfer = $json->{$Common::ConstValues::EDI_TRANSFER};
    if($ediTransfer) {
    	my $ediVHash = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer->fromJsonObjectToEDITransfer($ediTransfer);
    	$ret->setItsValue($ediVHash);
    	$ret->setItsType($Common::ConstValues::EDI_TRANSFER);
    }
    return $ret;
}
1;