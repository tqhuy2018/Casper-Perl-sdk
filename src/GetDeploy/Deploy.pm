=comment
This class is for storing Deploy information
=cut
package Deploy;
use JSON qw( decode_json );
sub new {
	my $class = shift;
	my $self = {
		_deployHash => shift,
		_header => shift,
		_payment => shift,
		_sesssion => shift,
		_approvals => shift,
	};
	bless $self, $class;
	return $self;
}

sub setDeployHash {
	my ( $self, $deployHash) = @_;
	$self->{_deployHash} = $deployHash if defined($deployHash);
	return $self->{_deployHash};
}

sub getDeployHash {
	my ( $self ) = @_;
	return $self->{_deployHash};
}

sub setHeader {
	my ( $self, $header) = @_;
	$self->{_header} = $header if defined($header);
	return $self->{_header};
}

sub getHeader {
	my ( $self ) = @_;
	return $self->{_header};
}
=comment
Static function - This function turn a json object to a deploy object
=cut
sub fromJsonObjectToDeploy {
	my ($class, @args) = @_;
    die "class method invoked on object" if ref $class;
    print "about to parse the json to get deploy";
	my $retDeploy = new Deploy();
	return $retDeploy;
}
=comment
This function log information of a deploy
=cut
sub logInfo {
	my ( $self ) = @_;
	print "\nDeploy hash:".$self->{_deployHash}."\n";
}
1;