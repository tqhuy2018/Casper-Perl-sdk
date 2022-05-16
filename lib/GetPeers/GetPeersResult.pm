=comment
This class store the information of GetPeersResult, which is the result of the  info_get_peers RPC call
This class also handles the parse of Json object to GetPeersResult object.
=cut
package GetPeers::GetPeersResult;
use GetPeers::PeerEntry;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
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

# This function turn a json object to a GetPeersResult object
sub fromJsonObjectToGetPeersResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetPeers::GetPeersResult();
	$ret->setApiVersion($json->{'api_version'});
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
