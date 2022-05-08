# Class built for storing GetBlockResult information, taken from chain_get_block RPC method
package GetBlock::GetBlockResult;
use GetBlock::JsonBlock;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_block => shift, # JsonBlock object, Optional value
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

# get-set method for _block
sub setBlock {
	my ( $self, $value) = @_;
	$self->{_block} = $value if defined($value);
	return $self->{_block};
}

sub getBlock {
	my ( $self ) = @_;
	return $self->{_block};
}

# This function parse the JsonObject (taken from server RPC method call) to GetBlockResult object
sub fromJsonObjectToGetBlockResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::GetBlockResult();
	$ret->setApiVersion($json->{'api_version'});
	my $jsonBlock = GetBlock::JsonBlock->fromJsonObjectToJsonBlock($json->{'block'});
	$ret->setBlock($jsonBlock);
	return $ret;
}
1;