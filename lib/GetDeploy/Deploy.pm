#This class is for storing Deploy information

package GetDeploy::Deploy;
use GetDeploy::Approval;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use Serialization::ExecutableDeployItemSerializationHelper;
use JSON qw( decode_json );
use CryptoHandle::Blake2b256Helper;
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

# This function counts the deploy body hash based on the serialization of the deploy payment and session
# The flow is:
# 1. take the deploy payment serialization
# 2. take the deploy session serialization
# 3. make the concatenation of deploy payment serialization and deploy session serialization
# 4. take the blake2b256 hash over the concatenation string.
sub getBodyHash {
	my ($self) = @_;
	my $payment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
 	$payment = $self->{_payment};
 	my $serializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
 	my $paymentSerialization = $serializationHelper->serializeForExecutableDeployItem($payment);
 	my $session = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
 	$session = $self->{_session};
 	my $sessionSerialization = $serializationHelper->serializeForExecutableDeployItem($session);
 	my $bodySerialization = $paymentSerialization.$sessionSerialization;
 	my $blake2b = new CryptoHandle::Blake2b256Helper();
 	return $blake2b->getBlake2b256($bodySerialization);
}

1;