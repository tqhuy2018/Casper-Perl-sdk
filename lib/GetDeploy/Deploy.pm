#This class is for storing Deploy information

package GetDeploy::Deploy;
use GetDeploy::Approval;
use JSON qw( decode_json );

sub new {
	my $class = shift;
	my $self = {
		_deployHash => shift,
		_header => shift,
		_payment => shift,
		_session => shift,
		_approvals => [ @_ ],
	};
	bless $self, $class;
	return $self;
}
# get-set method for Deploy Hash
sub setDeployHash {
	my ( $self, $deployHash) = @_;
	$self->{_deployHash} = $deployHash if defined($deployHash);
	return $self->{_deployHash};
}

sub getDeployHash {
	my ( $self ) = @_;
	return $self->{_deployHash};
}

# get-set method for Deploy Header
sub setHeader {
	my ( $self, $header) = @_;
	$self->{_header} = $header if defined($header);
	return $self->{_header};
}

sub getHeader {
	my ( $self ) = @_;
	return $self->{_header};
}

# get-set method for Deploy session
sub setSession {
	my ($self,$session) = @_;
	$self->{_session} = $session if defined ($session);
	return $self->{_session};
}
sub getSession {
	my ($self) = @_;
	return $self->{_session};
}

# get-set method for Deploy payment
sub setPayment {
	my ($self,$payment) = @_;
	$self->{_payment} = $payment if defined($payment);
	return $self->{_payment};
}
sub getPayment {
	my ($self) = @_;
	return $self->{_payment};
}
# get-set method for Approvals

sub setApprovals {
	my ($self, @approvals) = @_;
	$self->{_approvals} = \@approvals;
	return $self->{_approvals};
}
sub getApprovals {
	my ($self) = @_;
	my @approvals = @{ $self->{_approvals} };#$self->{_approvals};
	wantarray ? @approvals : \@approvals;
}

# This function turn Json Array to a list of Approval objects
sub fromJsonArrayToApprovalList {
	my @list = @_;
	my @json = @{$list[1]};
	my @approvalList = ();
	foreach(@json) {
		my $oneApprovalJson = $_;
		my $oneApproval = GetDeploy::Approval->fromJsonObjectToApproval($_);
		push(@approvalList,$oneApproval);
	}
	return @approvalList;
}

1;