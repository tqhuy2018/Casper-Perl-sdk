=comment
Class built for storing the  CLValue object.
Information of a sample CLValue object
{
"bytes": "0400e1f505"
"parsed": "100000000"
"cl_type": "U512"
}
=cut
package CLValue::CLValue;

use CLValue::CLType;
use CLValue::CLParse;
sub new {
	my $class = shift;
	my $self = {
		_clType => shift,
		_bytes => shift,
		_parse => shift,
	};
	bless $self, $class;
	return $self;
}

#get-set method for clType
sub setCLType {
	my ($self,$clType) = @_;
	$self->{_clType} = $clType if defined($clType);
	return $self->{_clType};
}

sub getCLType {
	my ($self) = @_;
	return $self->{_clType};
}

#get-set method for bytes
sub setBytes {
	my ($self,$bytes) = @_;
	$self->{_bytes} = $bytes if defined($bytes);
	return $self->{_bytes};
}
sub getBytes {
	my ($self) = @_;
	return $self->{_bytes};
}

#get-set method for parse
sub setParse {
	my ($self,$parse) = @_;
	$self->{_parse} = $parse if defined ($parse);
	return $self->{_parse};
}
sub getParse {
	my ($self) = @_;
	return $self->{_parse};
}

#Generate the CLValue object  from the JsonObject
sub fromJsonObjToCLValue {
	my @list = @_;
	my $json = $list[1];
	my $ret = new CLValue::CLValue();
	$ret->setBytes($json->{'bytes'});
	my $clType = CLValue::CLType->getCLType($json->{'cl_type'});
	$ret->setCLType($clType);
	my $clParse = CLValue::CLParse->getCLParsed($json->{'parsed'});
	$ret->setParse($clParse);
	return $ret;
}
1;