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
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem;

use JSON;

use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash;

sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless  $self, $class;
	return $self;
}

#get-set method for itsType

sub setItsType {
	my ($self,$itsType) = @_;
	$self->{_itsType} = $itsType if defined ($itsType);
	return $self->{_itsType};
}
sub getItsType {
	my ($self) = @_;
	return $self->{_itsType};
}

#get-set method for itsValue
sub setItsValue {
	my ($self,$itsValue) = @_;
	$self->{_itsValue} = $itsValue if defined($itsValue);
	return $self->{_itsValue};
}

sub getItsValue {
	my ($self) = @_;
	return $self->{_itsValue};
}

=comment
This function turn a json object to an ExecutableDeployItem object
=cut

sub fromJsonToExecutableDeployItem {
	my @list = @_;
	print "\nparameter in get deploy ExecutableDeployItem str is:".encode_json($list[1])."\n";
    print "about to parse the json to get deploy ExecutableDeployItem";
    #my $json = decode_json($list[1]);
    my $json = $list[1];
    my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
    my $ediMBJson = $json->{'ModuleBytes'};
    if($ediMBJson) {
    	print "\nedi of type ModuleBytes";
    	my $ediMB = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes->fromJsonObjectToEDIModuleBytes($ediMBJson);
    	$ret->setItsValue($ediMB);
    	$ret->setItsType("ModuleBytes");
    }
     my $ediSCBHJson = $json->{'StoredContractByHash'};
    if($ediSCBHJson) {
    	print "\nedi of type StoredContractByHash";
    	my $ediSCBH = GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash->fromJsonObjectToEDIStoredContractByHash($ediSCBHJson);
    	$ret->setItsValue($ediSCBH);
    	$ret->setItsType("StoredContractByHash");
    }
    return $ret;
}
1;