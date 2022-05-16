=comment
This class hold the information of GetStatusResult, which retrieved from the  info_get_peers RPC call
This class also handle the work of parsing Json object to a GetStatusResult object
=cut
package GetStatus::GetStatusResult;
use GetPeers::PeerEntry;
use GetStatus::MinimalBlockInfo;
use GetStatus::NextUpgrade;

sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_chainspecName => shift,
		_startingStateRootHash => shift,
		_lastAddedBlockInfo => shift, # MinimalBlockInfo object, Optional value
		_ourPublicSigningKey => shift, # Optional value
		_roundLength => shift, # Optional value
		_nextUpgrade => shift, # NextUpgrade object, Optional value
		_buildVersion => shift,
		_uptime => shift,
		_peers => [ @_ ], # List of PeerEntry
	};
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

# get-set method for _chainspecName
sub setChainspecName {
	my ( $self, $value) = @_;
	$self->{_chainspecName} = $value if defined($value);
	return $self->{_chainspecName};
}

sub getChainspecName {
	my ( $self ) = @_;
	return $self->{_chainspecName};
}

# get-set method for _startingStateRootHash
sub setStartingStateRootHash {
	my ( $self, $value) = @_;
	$self->{_startingStateRootHash} = $value if defined($value);
	return $self->{_startingStateRootHash};
}

sub getStartingStateRootHash {
	my ( $self ) = @_;
	return $self->{_startingStateRootHash};
}

# get-set method for _lastAddedBlockInfo
sub setLastAddedBlockInfo {
	my ( $self, $value) = @_;
	$self->{_lastAddedBlockInfo} = $value if defined($value);
	return $self->{_lastAddedBlockInfo};
}

sub getLastAddedBlockInfo {
	my ( $self ) = @_;
	return $self->{_lastAddedBlockInfo};
}

# get-set method for _ourPublicSigningKey
sub setOurPublicSigningKey {
	my ( $self, $value) = @_;
	$self->{_ourPublicSigningKey} = $value if defined($value);
	return $self->{_ourPublicSigningKey};
}

sub getOurPublicSigningKey {
	my ( $self ) = @_;
	return $self->{_ourPublicSigningKey};
}
# get-set method for _roundLength
sub setRoundLength {
	my ( $self, $value) = @_;
	$self->{_roundLength} = $value if defined($value);
	return $self->{_roundLength};
}

sub getRoundLength {
	my ( $self ) = @_;
	return $self->{_roundLength};
}
# get-set method for _nextUpgrade
sub setNextUpgrade {
	my ( $self, $value) = @_;
	$self->{_nextUpgrade} = $value if defined($value);
	return $self->{_nextUpgrade};
}

sub getNextUpgrade {
	my ( $self ) = @_;
	return $self->{_nextUpgrade};
}

# get-set method for _buildVersion
sub setBuildVersion {
	my ( $self, $value) = @_;
	$self->{_buildVersion} = $value if defined($value);
	return $self->{_buildVersion};
}

sub getBuildVersion {
	my ( $self ) = @_;
	return $self->{_buildVersion};
}

# get-set method for _uptime
sub setUptime {
	my ( $self, $value) = @_;
	$self->{_uptime} = $value if defined($value);
	return $self->{_uptime};
}

sub getUptime {
	my ( $self ) = @_;
	return $self->{_uptime};
}
# get-set method for _peers
sub setPeers {
	my ( $self, @value) = @_;
	$self->{_peers} = \@value;
	return $self->{_peers};
}

sub getPeers {
	my ( $self ) = @_;
	my @list = @{$self->{_peers}};
	wantarray ? @list : \@list;
}

# This function parse a Json object to a GetPeersResult object
sub fromJsonObjectToGetStatusResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetStatus::GetStatusResult();
	$ret->setApiVersion($json->{'api_version'});
	$ret->setChainspecName($json->{'chainspec_name'});
	$ret->setStartingStateRootHash($json->{'starting_state_root_hash'});
	$ret->setBuildVersion($json->{'build_version'});
	$ret->setUptime($json->{'uptime'});
	if($json->{'last_added_block_info'}) {
		$ret->setLastAddedBlockInfo(GetStatus::MinimalBlockInfo->fromJsonObjectToMinimalBlockInfo($json->{'last_added_block_info'}));
	}
	if($json->{'our_public_signing_key'}) {
		$ret->setOurPublicSigningKey($json->{'our_public_signing_key'});
	}
	if($json->{'round_length'}) {
		$ret->setRoundLength($json->{'round_length'});
	}
	if($json->{'next_upgrade'}) {
		$ret->setNextUpgrade(GetStatus::NextUpgrade->fromJsonObjectToNextUpgrade($json->{'next_upgrade'}));
	} 
	my @peerListJson = @{$json->{'peers'}};
	my @peers = ();
	foreach(@peerListJson) {
		my $onePE = GetPeers::PeerEntry->fromJsonObjectToPeerEntry($_);
		push(@peers,$onePE);
	}
	$ret->setPeers(@peers);
	return $ret;
}
1;
