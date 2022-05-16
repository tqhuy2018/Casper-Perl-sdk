=comment
This class is for storing Approval information, which include the two atrributes: signer and signatureis
This class handles the change from Json object to TransformEntry object
=cut

package GetDeploy::Approval;

sub new {
	my $class = shift;
	my $self = {
		_signer => shift,
		_signature => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set function for _signer
sub setSigner {
	my ($self, $signer) = @_;
	$self->{_signer} = $signer if defined($signer);
	return $self->{_signer};
}
sub getSigner {
	my ($self) = @_;
	return $self->{_signer};
}

#get-set function for signature
sub setSignature {
	my ($self, $signature) = @_;
	$self->{_signature} = $signature if defined($signature);
	return $self->{_signature};
}
sub getSignature {
	my ($self) = @_;
	return $self->{_signature};
}

#This function turn a Json object to an Approval object
sub fromJsonObjectToApproval {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::Approval();
    $ret->setSigner($json->{'signer'});
    $ret->setSignature($json->{'signature'});
	return $ret;
}
1;