package GetDeploy::ExecutableDeployItem::NamedArg;

use JSON;
use CLValue::CLType;

sub new {
	my $class = shift;
	my $self = {
		_itsName => shift,
		_clValue => shift,
	};
	bless $self, $class;
	return $self;
}

#get-set method for _itsName

sub setItsName {
	my ($self,$itsName) = @_;
	$self->{_itsName} = $itsName if defined ($itsName);
	return $self->{_itsName};
}
sub getItsName {
	my ($self) = @_;
	return $self->{_itsName};
}

#get-set method for clValue

sub setCLValue {
	my ($self,$clValue) = @_;
	$self->{_clValue} = $clValue if defined ($clValue);
	return $self->{_clValue};
}
sub getCLValue {
	my ($self) = @_;
	return $self->{_clValue};
}
sub fromJsonArrayToNamedArg {
	my @list = @_;
	my $jsonStr = encode_json($list[1]);
    my @nameArgJson = @{$list[1]};
   	my $counter = 0;
   	my $ret = new GetDeploy::ExecutableDeployItem::NamedArg();
	foreach(@nameArgJson) {
    	if($counter == 0) {
    		my $account = $_;
   			print "counter 0, itsName is:".$account."\n";
   			$ret->setItsName($account);
   		} elsif($counter == 1) {
   			my $clValue = $_;
   			my $bytes = $clValue->{'bytes'};
   			print "byte is:".$bytes."\n";
   			my $clTypeStr = $clValue->{'cl_type'};
   			print "From get Arg of Session and Payment, clType is:".$clTypeStr."\n";
   			my $clType = CLValue::CLType->getCLType($clTypeStr);
   			print "*******------******After parseing, the cltype is:".$clType->getItsTypeStr()."\n";
   		}
    	$counter ++;
    }
    return $ret;
}
1;