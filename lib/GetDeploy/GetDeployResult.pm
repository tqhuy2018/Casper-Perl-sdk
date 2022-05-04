=comment
This class stored the information of the GetDeployRPC call and encapsulated it 
in the class GetDeployResult
=cut
package GetDeploy::GetDeployResult;

use JSON qw( decode_json );
use JSON qw( encode_json );

sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_deploy => shift,
		_executionResults => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _apiVersion
sub setApiVersion {
	my ($self,$value) = @_;
	$self->{_apiVersion} = $value if defined($value);
	return $self->{_apiVersion};
}
sub getApiVersion {
	my ($self)  = @_;
	return $self->{_apiVersion};
}

# get-set method for _deploy
sub setDeploy {
	my ($self,$value) = @_;
	$self->{_deploy} = $value if defined($value);
	return $self->{_deploy};
}
sub getDeploy {
	my ($self)  = @_;
	return $self->{_deploy};
}

# get-set method for _executionResults
sub setExecutionResults {
	my ($self,$value) = @_;
	$self->{_executionResults} = $value if defined($value);
	return $self->{_executionResults};
}
sub getExecutionResults {
	my ($self)  = @_;
	return $self->{_executionResults};
}

# This function turn a json object to a GetDeployResult object
sub fromJsonObjectToGetDeployResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::GetDeployResult();
    my $deploy = new GetDeploy::Deploy();
    	
	 #get deploy header
    my $deployHeaderJson = $json->{'deploy'}{'header'};
    my $deployHeader = GetDeploy::DeployHeader->fromJsonObjectToDeployHeader($deployHeaderJson);
    print "\ndeploy header hash: ".$deployHeader->getBodyHash()."\n";
    $deploy->setDeployHash($json->{'deploy'}{'hash'});
    $deploy->setHeader($deployHeader);
    
    #get deploy payment
    my $paymentJson = $json->{'deploy'}{'payment'};
    my $payment = GetDeploy::ExecutableDeployItem::ExecutableDeployItem->fromJsonToExecutableDeployItem($paymentJson);
    $deploy->setPayment($payment);
    
    #get deploy session
    my $sessionJson = $json->{'deploy'}{'session'};
    my $session = GetDeploy::ExecutableDeployItem::ExecutableDeployItem->fromJsonToExecutableDeployItem($sessionJson);
    $deploy->setSession($session);
    
    #get deploy approval list
    my @approvalList = GetDeploy::Deploy->fromJsonArrayToApprovalList($json->{'deploy'}{'approvals'});
    $deploy->setApprovals(@approvalList);
    foreach(@approvalList) {
    	my $oneA = $_;
    	print("In parsing Deploy, approval signer:".$oneA->getSigner()."\n");
    }
    #get the execution_results
    
    $ret->setDeploy($deploy);
    return $ret;
}
1;