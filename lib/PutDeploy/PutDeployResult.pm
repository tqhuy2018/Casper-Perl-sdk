# This class handles and stores the result when call for account_put_deploy RPC call
package PutDeploy::PutDeployResult;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );

sub new {
	my $class = shift;
	my $self = {_apiVersion => shift,_deployHash => shift,};
	bless $self, $class;
	return $self;
}
# get-set method for _apiVersion
sub setApiVersion {
	my ( $self, $value) = @_;
	$self->{_apiVersion} = $value if defined($value);
	return $self->{_apiVersion};
}

sub getApiVersion {
	my ( $self ) = @_;
	return $self->{_apiVersion};
}

# get-set method for _deployHash
sub setDeployHash {
	my ( $self, $value) = @_;
	$self->{_deployHash} = $value if defined($value);
	return $self->{_deployHash};
}

sub getDeployHash {
	my ( $self ) = @_;
	return $self->{_deployHash};
}

# This function parse a Json object to a PutDeployResult object
# input: an Json object
# output: PutDeployResult object
sub fromJsonObjectToPutDeployResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new PutDeploy::PutDeployResult();
	$ret->setApiVersion($json->{'api_version'});
	$ret->setDeployHash($json->{'deploy_hash'});
	return $ret;
}
1;