# Class built for storing Bid information
# and handles the change from Json object to CasperTransfer object
package GetDeploy::ExecutionResult::Transform::CasperTransfer;
use Scalar::Util qw(looks_like_number);
sub new {
	my $class = shift,
	my $self = {
		_deployHash => shift,
		_from => shift,
		_to => shift, # Optional value
		_id => shift, # Optional value
		_source => shift,
		_target => shift,
		_amount => shift, 
		_gas => shift,
	};
	bless $self,$class;
	return $self;
}

# get-set method for _deployHash
sub setDeployHash {
	my ($self,$deployHash) = @_;
	$self->{_deployHash} = $deployHash if defined($deployHash);
	return $self->{_deployHash};
}
sub getDeployHash {
	my ($self)  = @_;
	return $self->{_deployHash};
}

# get-set method for _from
sub setFrom {
	my ($self,$from) = @_;
	$self->{_from} = $from if defined($from);
	return $self->{_from};
}
sub getFrom {
	my ($self)  = @_;
	return $self->{_from};
}

# get-set method for _to
sub setTo {
	my ($self,$to) = @_;
	$self->{_to} = $to if defined($to);
	return $self->{_to};
}
sub getTo {
	my ($self)  = @_;
	return $self->{_to};
}

# get-set method for _id
sub setId {
	my ($self,$id) = @_;
	$self->{_id} = $id if defined($id);
	return $self->{_id};
}
sub getId {
	my ($self)  = @_;
	return $self->{_id};
}

# get-set method for _source
sub setSource {
	my ($self,$source) = @_;
	$self->{_source} = $source if defined($source);
	return $self->{_source};
}
sub getSource {
	my ($self)  = @_;
	return $self->{_source};
}

# get-set method for _target
sub setTarget {
	my ($self,$target) = @_;
	$self->{_target} = $target if defined($target);
	return $self->{_target};
}
sub getTarget {
	my ($self)  = @_;
	return $self->{_target};
}

# get-set method for _amount
sub setAmount {
	my ($self,$amount) = @_;
	$self->{_amount} = $amount if defined($amount);
	return $self->{_amount};
}
sub getAmount {
	my ($self)  = @_;
	return $self->{_amount};
}

# get-set method for _gas
sub setGas {
	my ($self,$gas) = @_;
	$self->{_gas} = $gas if defined($gas);
	return $self->{_gas};
}
sub getGas {
	my ($self)  = @_;
	return $self->{_gas};
}

# This function parse the JsonObject (taken from server RPC method call) to get the CasperTransfer object
sub fromJsonToTransfer {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::CasperTransfer();
	$ret->setDeployHash($json->{'deploy_hash'});
	$ret->setFrom($json->{'from'});
	if($json->{'to'}) {
		$ret->setTo($json->{'to'});
	}
	$ret->setSource($json->{'source'});
	$ret->setTarget($json->{'target'});
	$ret->setAmount($json->{'amount'});
	$ret->setGas($json->{'gas'});
	my $id = $json->{'id'};
	if(looks_like_number($id)) {
		$ret->setId($json->{'id'});
	}
	return $ret;
}
1;