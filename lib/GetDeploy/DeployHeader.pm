=comment
This class is for storing Deploy header information
=cut

package GetDeploy::DeployHeader;

sub new {
	my $class = shift;
	my $self = {
		_account => shift,
		_bodyHash => shift,
		_chainName => shift,
		_dependencies => shift,
		_gasPrice => shift,
		_timeStamp => shift,
		_ttl => shift,
	};
	bless $self, $class;
	return $self;
}

sub setAccount {
	my ( $self, $account) = @_;
	$self->{_account} = $account if defined($account);
	return $self->{_account};
}

sub getAccount {
	my ( $self ) = @_;
	return $self->{_account};
}

sub setBodyHash {
	my ( $self, $bodyHash) = @_;
	$self->{_bodyHash} = $bodyHash if defined($bodyHash);
	return $self->{_bodyHash};
}

sub getBodyHash {
	my ( $self ) = @_;
	return $self->{_bodyHash};
}

sub setChainName {
	my ( $self, $chainName) = @_;
	$self->{_chainName} = $chainName if defined($chainName);
	return $self->{_chainName};
}

sub getChainName {
	my ( $self ) = @_;
	return $self->{_chainName};
}
=comment
This function log information of a deploy header
=cut
sub logInfo {
	my ( $self ) = @_;
	print "\nDeploy header account :".$self->{_account}."\n";
}
1;