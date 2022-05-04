# Class built for storing TransformEntry information

package GetDeploy::ExecutionResult::TransformEntry;
use GetDeploy::ExecutionResult::CasperTransform;
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
		print "Transform Entry of type Identity";
		$transform->setItsType("Identity");
		$ret->setTransform($transform);
	} elsif ($transformJson eq "WriteContractWasm") {
		print "Transform Entry of type WriteContractWasm";
		$transform->setItsType("WriteContractWasm");
		$ret->setTransform($transform);
	} elsif ($transformJson eq "WriteContract") {
		print "Transform Entry of type WriteContract";
		$transform->setItsType("WriteContract");
		$ret->setTransform($transform);
	} elsif ($transformJson eq "WriteContractPackage") {
		print "Transform Entry of type WriteContractPackage";
		$transform->setItsType("WriteContractPackage");
		$ret->setTransform($transform);
	} elsif ($transformJson->{'AddInt32'}) {
			$transform->setItsType("AddInt32");
			$transform->setItsValue($transformJson->{'AddInt32'});
			print "\nTransformEntry Of type AddInt32\n";
	} elsif ($transformJson->{'AddUInt64'}) {
			$transform->setItsType("AddUInt64");
			$transform->setItsValue($transformJson->{'AddUInt64'});
			print "\nTransformEntry Of type AddUInt64\n";
	} elsif ($transformJson->{'AddUInt128'}) {
			$transform->setItsType("AddUInt128");
			$transform->setItsValue($transformJson->{'AddUInt128'});
			print "\nTransformEntry Of type AddUInt128\n";
	} elsif ($transformJson->{'AddUInt256'}) {
			$transform->setItsType("AddUInt256");
			$transform->setItsValue($transformJson->{'AddUInt256'});
			print "\nTransformEntry Of type AddUInt256\n";
	} elsif ($transformJson->{'AddUInt512'}) {
			$transform->setItsType("AddUInt512");
			$transform->setItsValue($transformJson->{'AddUInt512'});
			print "\nTransformEntry Of type AddUInt512\n";
	} elsif ($transformJson->{'Failure'}) {
			$transform->setItsType("Failure");
			$transform->setItsValue($transformJson->{'Failure'});
			print "\nTransformEntry Of type Failure\n";
	} elsif ($transformJson->{'WriteCLValue'}) {
			$transform->setItsType("WriteCLValue");
			#my $clValue = CLValue::CLValue->fromJsonObjToCLValue($transformJson->{'WriteCLValue'});
			my $clValueJson = $transformJson->{'WriteCLValue'};
			$transform->setItsValue($transformJson->{'WriteCLValue'});
			my $clType = CLValue::CLType->getCLType($clValueJson->{'cl_type'});
   			my $clParse = CLValue::CLParse->getCLParsed($clValueJson->{'parsed'},$clType);
   			my $clValue = new CLValue::CLValue();
   			$clValue->setBytes($bytes);
   			$clValue->setCLType($clType);
   			$clValue->setParse($clParse);
			$transform->setItsValue($clValue);
			print "\nTransformEntry Of type WriteCLValue\n";
	}
	print "\nKey of TransformEntry is:".$json->{'key'}."\n";
	return $ret;
}
1;