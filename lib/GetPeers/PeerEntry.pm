=comment
This class is for storing PeerEntry information, and handles the work of parsing Json object to a PeerEntry object.
=cut

package GetPeers::PeerEntry;

sub new {
	my $class = shift;
	my $self = {
		_nodeId => shift,
		_address => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _nodeId
sub setNodeId {
	my ( $self, $value) = @_;
	$self->{_nodeId} = $value if defined($value);
	return $self->{_nodeId};
}

sub getNodeId {
	my ( $self ) = @_;
	return $self->{_nodeId};
}

# get-set method for _address
sub setAddress {
	my ( $self, $value) = @_;
	$self->{_address} = $value if defined($value);
	return $self->{_address};
}

sub getAddress {
	my ( $self ) = @_;
	return $self->{_address};
}

# This function parse a Json object to a PeerEntry object
sub fromJsonObjectToPeerEntry {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetPeers::PeerEntry();
	$ret->setNodeId($json->{'node_id'});
	$ret->setAddress($json->{'address'});
	return $ret;
}

1;