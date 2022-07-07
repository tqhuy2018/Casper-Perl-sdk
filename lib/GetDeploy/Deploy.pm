#This class is for storing Deploy information

package GetDeploy::Deploy;
use GetDeploy::Approval;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use Serialization::ExecutableDeployItemSerializationHelper;
use JSON qw( decode_json );
use Crypt::Digest::BLAKE2b_256 qw( blake2b_256 blake2b_256_hex blake2b_256_b64 blake2b_256_b64u
                             blake2b_256_file blake2b_256_file_hex blake2b_256_file_b64 blake2b_256_file_b64u );
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
 	print "Payment serialization:".$paymentSerialization."\n";
 	my $session = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
 	$session = $self->{_session};
 	my $sessionSerialization = $serializationHelper->serializeForExecutableDeployItem($session);
 	print "Session serialization:".$sessionSerialization."\n";
 	my $bodySerialization = $paymentSerialization.$sessionSerialization;
 	print "Body serialization:".$bodySerialization."\n";
 	my $length = length($bodySerialization)/2;
 	my @sequence = (0..$length-1);
 	my @list = ();
 	for my $i (@sequence) {
 		my $twoChar = substr $bodySerialization, $i * 2,2;
 		my $firstChar = substr $twoChar,0,1;
 		my $secondChar = substr $twoChar,1,1;
 		my $valueHex = hex($firstChar) * 16 + hex($secondChar);
 		push(@list,$valueHex);
 	}
 	my $total = @list;
	my @sequence2 = (0..$total-1);
	my $str = "";
	for my $i (@sequence2) {
		my $oneChar = chr($list[$i]);
		$str = $str.$oneChar;
	}
	return blake2b_256_hex($str);
}

1;