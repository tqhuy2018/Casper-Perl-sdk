# Class built for storing JsonBlock information
package GetBlock::JsonBlock;
use GetBlock::JsonBlockBody;
use GetBlock::JsonBlockHeader;
use GetBlock::JsonProof;
sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_header => shift, # JsonBlockHeader object
		_body => shift, # JsonBlockBody object
		_proofs => [ @_ ], # list of JsonProof
	};
	bless $self, $class;
	return $self;
}

# get-set method for _blockHash
sub setBlockHash {
	my ( $self, $value) = @_;
	$self->{_blockHash} = $value if defined($value);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}

# get-set method for _header
sub setHeader {
	my ( $self, $value) = @_;
	$self->{_header} = $value if defined($value);
	return $self->{_header};
}

sub getHeader {
	my ( $self ) = @_;
	return $self->{_header};
}

# get-set method for _body
sub setBody {
	my ( $self, $value) = @_;
	$self->{_body} = $value if defined($value);
	return $self->{_body};
}

sub getBody {
	my ( $self ) = @_;
	return $self->{_body};
}

# get-set method for _proofs
sub setProofs {
	my ( $self, @value) = @_;
	$self->{_proofs} = \@value;
	return $self->{_proofs};
}

sub getProofs {
	my ( $self ) = @_;
	my @list = @{$self->{_proofs}};
	wantarray ? @list : \@list;
}

# This function parse the JsonObject (taken from server RPC method call) to JsonBlock object
sub fromJsonObjectToJsonBlock {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonBlock();
	$ret->setBlockHash($json->{'hash'});
	my $header = GetBlock::JsonBlockHeader->fromJsonObjectToJsonBlockHeader($json->{'header'});
	$ret->setHeader($header);
	my $body = GetBlock::JsonBlockBody->fromJsonObjectToJsonBlockBody($json->{'body'});
	$ret->setBody($body);
	my @listProofJson = @{$json->{'proofs'}};
	my $totalProof = @listProofJson;
	if($totalProof > 0) {
		my @listProof = ();
		foreach(@listProofJson) {
			my $oneProof = GetBlock::JsonProof->fromJsonToJsonProof($_);
			push(@listProof,$oneProof);
		}
		$ret->setProofs(@listProof);
	}
	return $ret;
}
1;