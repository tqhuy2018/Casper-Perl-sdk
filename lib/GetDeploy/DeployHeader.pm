=comment
This class is for storing Deploy header information
and handles the change from Json object to DeployHeader object
=cut

package GetDeploy::DeployHeader;

use JSON qw( decode_json );
use Serialization::DeploySerializeHelper;
use CryptoHandle::Blake2b256Helper();
sub new {
	my $class = shift;
	my $self = {
		_account => shift,
		_bodyHash => shift,
		_chainName => shift,
		_dependencies => [ @_ ],
		_gasPrice => shift,
		_timeStamp => shift,
		_ttl => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set methods for account
sub setAccount {
	my ( $self, $account) = @_;
	$self->{_account} = $account if defined($account);
	return $self->{_account};
}

sub getAccount {
	my ( $self ) = @_;
	return $self->{_account};
}

# get-set methods for body_hash
sub setBodyHash {
	my ( $self, $bodyHash) = @_;
	$self->{_bodyHash} = $bodyHash if defined($bodyHash);
	return $self->{_bodyHash};
}

sub getBodyHash {
	my ( $self ) = @_;
	return $self->{_bodyHash};
}

# get-set methods for chain_name
sub setChainName {
	my ( $self, $chainName) = @_;
	$self->{_chainName} = $chainName if defined($chainName);
	return $self->{_chainName};
}

sub getChainName {
	my ( $self ) = @_;
	return $self->{_chainName};
}

# get-set methods for timestamp
sub setTimestamp {
	my ( $self, $timeStamp) = @_;
	$self->{_timeStamp} = $timeStamp if defined($timeStamp);
	return $self->{_timeStamp};
}

sub getTimestamp {
	my ( $self ) = @_;
	return $self->{_timeStamp};
}

# get-set methods for ttl
sub setTTL {
	my ( $self, $ttl) = @_;
	$self->{_ttl} = $ttl if defined($ttl);
	return $self->{_ttl};
}

sub getTTL {
	my ( $self ) = @_;
	return $self->{_ttl};
}

# get-set methods for gas_price
sub setGasPrice {
	my ( $self, $gasPrice) = @_;
	$self->{_gasPrice} = $gasPrice if defined($gasPrice);
	return $self->{_gasPrice};
}

sub getGasPrice {
	my ( $self ) = @_;
	return $self->{_gasPrice};
}

# get-set methods for dependencies
sub setDependencies {
	my ( $self, @dependencies) = @_;
	$self->{_dependencies} = \@dependencies;
	return $self->{_dependencies};
}

sub getDependencies {
	my ( $self ) = @_;
	my @dependencies = @{ $self->{_dependencies} };
	wantarray ? @dependencies :\@dependencies;
}

# This function turn a json object to a deploy header object
sub fromJsonObjectToDeployHeader {
	my @list = @_;
    #my $json = decode_json($list[1]);
    my $json = $list[1];
	my $retDeployHeader = new GetDeploy::DeployHeader();
	$retDeployHeader->setBodyHash($json->{'body_hash'});
	$retDeployHeader->setAccount($json->{'account'});
	$retDeployHeader->setChainName($json->{'chain_name'});
	$retDeployHeader->setTTL($json->{'ttl'});
	$retDeployHeader->setTimestamp($json->{'timestamp'});
	$retDeployHeader->setGasPrice($json->{'gas_price'});
	my @dependencies = @{$json->{'dependencies'}};
	#$retDeployHeader->setDependencies($json->{'dependencies'});
	$retDeployHeader->setDependencies(@dependencies);
	return $retDeployHeader;
}

# This function counts the deploy hash based on the the Deploy header serialization
# Just take the serialization of the deploy header, then use blake2b256 over the deploy header serialization.
sub getDeployHash {
	my ( $self ) = @_;
	my $serializationHelper = new  Serialization::DeploySerializeHelper();
	my $headerSerialization = $serializationHelper->serializeForHeader($self);
	my $blake2b = new CryptoHandle::Blake2b256Helper();
	return $blake2b->getBlake2b256($headerSerialization);
}
1;