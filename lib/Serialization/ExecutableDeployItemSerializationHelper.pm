=comment
This class does the serialization for the ExecutableDeployItem object.
=cut

use CLValue::CLType;
use CLValue::CLParse;
use CLValue::CLValue;
use Common::ConstValues;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;
use GetDeploy::ExecutableDeployItem::NamedArg;
use  Serialization::CLTypeSerialization;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;

package Serialization::ExecutableDeployItemSerializationHelper;



#constructor
sub new {
	my $class = shift;
	my $self = {
			};
	bless $self, $class;
	return $self;
}

# This function does the serialization for RuntimeArgs object
sub serializeForRuntimeArgs {
	my $input = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @list = @_;
	$input = $list[1];
	my @listNA = $input->getListNamedArg();
	my $totalNamedArg = @listNA;
	# If args is emtpy, just return "00000000" - same as U32 serialization for 0 (0 item)
	if($totalNamedArg == 0) {
		return "00000000";
	}
	# if args is not empty, first take u32 serialization for the number of args
	my $parse32 = new CLValue::CLParse();
	my $type32 = new CLValue::CLType();
	$type32->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	$parse32->setItsCLType($type32);
	$parse32->setItsValueStr("$totalNamedArg");
	my $parseSerialization = new Serialization::CLParseSerialization();
	my $typeSerialization = new  Serialization::CLTypeSerialization();
	my $ret = $parseSerialization->serializeFromCLParse($parse32);
	my @sequence = (0..$totalNamedArg-1);
	my $parseString = new CLValue::CLParse();
	my $typeString = new CLValue::CLType();
	$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
	$parseString->setItsCLType($typeString);
	my $oneNANameSerialization = "";
	for my $i (@sequence) {
		my $oneNA = new GetDeploy::ExecutableDeployItem::NamedArg();
		$oneNA = $listNA[$i];
		# Serialization for NamedArg.itsName, just the String serialize on itsName
		$parseString->setItsValueStr($oneNA->getItsName());
		$oneNANameSerialization =  $parseSerialization->serializeFromCLParse($parseString);
		# Serialization for NamedArg.itsCLValue
        # The flow of doing this: First serialize the CLValue parse - let call parsedSerialization
        # Serialize CLType - let call it clTypeSerialization
        # result = U32.serialize(parsedSerialization.length) + parsedSerialization + clTypeSerialization
        my $clValue = new CLValue::CLValue();
        $clValue = $oneNA->getCLValue();
        my $parseSerializationNA = $parseSerialization->serializeFromCLParse($clValue->getParse());
        my $typeSerializationNA = $typeSerialization->serializeForCLType($clValue->getCLType());
        my $parseLength = length($parseSerializationNA)/2;
        $parse32->setItsValueStr("$parseLength");
        my $parseLengthSerialization =  $parseSerialization->serializeFromCLParse($parse32);
        my $clValueSerialization = $parseLengthSerialization.$parseSerializationNA.$typeSerializationNA;
        $ret = $ret.$oneNANameSerialization.$clValueSerialization;
	}
	return $ret;
}

=comment
This function do the serialization for ExecutableDeployItem, which can be among 1 of 6 value type:
ModuleBytes, StoredContractByHash, StoredContractByName, StoredVersionedContractByHash, 
StoredVersionedContractByName, Transfer
=cut
sub serializeForExecutableDeployItem {
	my $input = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	my @list = @_;
	$input = $list[1];
	my $ediType = $input->getItsType();
	my $ret = "";
	# Serialization for ExecutableDeployItem of type ModuleBytes
	if($ediType eq $Common::ConstValues::EDI_MODULE_BYTES) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes();
		$realItem = $input->getItsValue();
		# prefix 00 for ExecutableDeployItem as type ModuleBytes
        $ret = "00";          
        # serialization for module_bytes
        # if module_bytes is blank, just return U32 serialization for value 0, which equals to "00000000"
        # if module_bytes is not blank, ret = "00" + moduleBytes.StringSerialization + args.Serialization
        my $moduleBytesSerialization = "";
        my $moduleBytes = $realItem->getModuleBytes();
        if($moduleBytes eq "") {
        	$moduleBytesSerialization = "00000000";
        } else {
        	my $parseString = new CLValue::CLParse();
			my $typeString = new CLValue::CLType();
			$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
			$parseString->setItsCLType($typeString);
			$parseString->setItsValueStr("$moduleBytes");
			my $parseSerialization = new Serialization::CLParseSerialization();
			$moduleBytesSerialization = $parseSerialization->serializeFromCLParse($parseString);
        }
        $ret = $ret.$moduleBytesSerialization;
        my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
        $ret = $ret.$runtimeArgsSerialization;
        return $ret;
	}
	# Serialization for ExecutableDeployItem of type StoredContractByHash 
	elsif($ediType eq $Common::ConstValues::EDI_STORED_CONTRACT_BY_HASH) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash();
		$realItem = $input->getItsValue();
		# prefix 01 for ExecutableDeployItem as type StoredContractByHash
        # the result = "01" + hash + String.Serialize(entry_point) + args.Serialization
        $ret = "01";
        my $parseString = new CLValue::CLParse();
		my $typeString = new CLValue::CLType();
		$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
		$parseString->setItsCLType($typeString);
		$parseString->setItsValueStr($realItem->getEntryPoint());
		my $parseSerialization = new Serialization::CLParseSerialization();
		my $entryPointSerialization = $parseSerialization->serializeFromCLParse($parseString);
		my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
		$ret = $ret.$realItem->getItsHash().$entryPointSerialization.$runtimeArgsSerialization;
		return $ret;
	}
	# Serialization for ExecutableDeployItem of type StoredContractByName
	elsif($ediType eq $Common::ConstValues::EDI_STORED_CONTRACT_BY_NAME) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName();
		$realItem = $input->getItsValue();
		# prefix 02 for ExecutableDeployItem as type StoredContractByName
        # the result = "02" + String.Serialize(name) + String.Serialize(entry_point) + Args.Serialization
        $ret = "02";
		my $parseSerialization = new Serialization::CLParseSerialization();
		
        # get String.Serialize(name)
        my $parseString = new CLValue::CLParse();
		my $typeString = new CLValue::CLType();
		$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
		$parseString->setItsCLType($typeString);
		$parseString->setItsValueStr($realItem->getItsName());
		my $nameSerialization = $parseSerialization->serializeFromCLParse($parseString);
		
		# get String.Serialize(entry_point)
		$parseString->setItsValueStr($realItem->getEntryPoint());
		my $entryPointSerialization = $parseSerialization->serializeFromCLParse($parseString);
		my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
		$ret = $ret.$nameSerialization.$entryPointSerialization.$runtimeArgsSerialization;
		return $ret;    
	}
	# Serialization for ExecutableDeployItem of type StoredVersionedContractByHash
	elsif($ediType eq $Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_HASH) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash();
		$realItem = $input->getItsValue();
		my $parseSerialization = new Serialization::CLParseSerialization();
		# prefix 03 for ExecutableDeployItem as type StoredVersionedContractByHash
        # the result = "03" + hash + Option(U32).Serialize(version) + String.Serialize(entry_point) + Args.Serialized
          $ret = "03";
        # get Option(U32).Serialize(version) 
        my $parseOption = new CLValue::CLParse();
        my $typeOption = new CLValue::CLType();
        $typeOption->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
        $parseOption->setItsCLType($typeOption);
        my $version = $realItem->getVersion();
        if(defined $version) {
        	if($version eq $Common::ConstValues::NULL_VALUE) {
        		$parseOption->setItsValueStr($Common::ConstValues::NULL_VALUE);
        	} else {
	        	my $parse32 = new CLValue::CLParse();
	        	my $type32 = new CLValue::CLType();
	        	$type32->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	        	$parse32->setItsCLType($type32);
	        	$parse32->setItsValueStr($version);
	        	$parseOption->setInnerParse1($parse32);
	        	$parseOption->setItsValueStr("not null");
       		}
        } else {
        	$parseOption->setItsValueStr($Common::ConstValues::NULL_VALUE);
        }
        my $versionSerialization = $parseSerialization->serializeFromCLParse($parseOption);
        
        # get String.Serialize(entry_point)
        my $parseString = new CLValue::CLParse();
		my $typeString = new CLValue::CLType();
		$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
		$parseString->setItsCLType($typeString);
		$parseString->setItsValueStr($realItem->getEntryPoint());
		my $entryPointSerialization = $parseSerialization->serializeFromCLParse($parseString);
		# get Args.Serialized
		my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
		$ret = $ret.$realItem->getItsHash().$versionSerialization.$entryPointSerialization.$runtimeArgsSerialization;
		return $ret;
	}
	# Serialization for ExecutableDeployItem of type StoredVersionedContractByName
	elsif($ediType eq $Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_NAME) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName();
		$realItem = $input->getItsValue();
		my $parseSerialization = new Serialization::CLParseSerialization();
		# prefix 04 for ExecutableDeployItem as type StoredVersionedContractByHash
        # the result = "04" + String.Serialize(name) + Option(U32).Serialize(version) + String.Serialize(entry_point) + Args.Serialized
          $ret = "04";
        # get Option(U32).Serialize(version) 
        my $parseOption = new CLValue::CLParse();
        my $typeOption = new CLValue::CLType();
        $typeOption->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
        $parseOption->setItsCLType($typeOption);
        my $version = $realItem->getVersion();
        if(defined $version) {
        	if($version eq $Common::ConstValues::NULL_VALUE) {
        		$parseOption->setItsValueStr($Common::ConstValues::NULL_VALUE);
        	} else {
	        	my $parse32 = new CLValue::CLParse();
	        	my $type32 = new CLValue::CLType();
	        	$type32->setItsTypeStr($Common::ConstValues::CLTYPE_U32);
	        	$parse32->setItsCLType($type32);
	        	$parse32->setItsValueStr($version);
	        	$parseOption->setInnerParse1($parse32);
	        	$parseOption->setItsValueStr("not null");
       		}
        } else {
        	$parseOption->setItsValueStr($Common::ConstValues::NULL_VALUE);
        }
        my $versionSerialization = $parseSerialization->serializeFromCLParse($parseOption);
        # get String.Serialize(name)
        my $parseString = new CLValue::CLParse();
		my $typeString = new CLValue::CLType();
		$typeString->setItsTypeStr($Common::ConstValues::CLTYPE_STRING);
		$parseString->setItsCLType($typeString);
		$parseString->setItsValueStr($realItem->getItsName());
		my $nameSerialization = $parseSerialization->serializeFromCLParse($parseString);
        
        # get String.Serialize(entry_point)
		$parseString->setItsValueStr($realItem->getEntryPoint());
		my $entryPointSerialization = $parseSerialization->serializeFromCLParse($parseString);
		# get Args.Serialized
		my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
		$ret = $ret.$nameSerialization.$versionSerialization.$entryPointSerialization.$runtimeArgsSerialization;
		return $ret;
	}
	# Serialization for ExecutableDeployItem of type Transfer
	elsif($ediType eq $Common::ConstValues::EDI_TRANSFER) {
		my $realItem = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
		$realItem = $input->getItsValue();
		# prefix 05 for ExecutableDeployItem as type Trasfer
        # the result = "05" + Args.Serialized
        my $runtimeArgsSerialization = serializeForRuntimeArgs("0",$realItem->getArgs());
        return "05".$runtimeArgsSerialization; 
	}
}
1;