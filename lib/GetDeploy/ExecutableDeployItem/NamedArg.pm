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
	print "\nparameter in get deploy NamedArg str is:".$list[1]."\n";
	my $jsonStr = encode_json($list[1]);
    print "In NamedArg: ---- value in JSON:".$jsonStr."\n";
    my @nameArgJson = @{$list[1]};
   	my $counter = 0;
	foreach(@nameArgJson) {
    	if($counter == 0) {
    		my $account = $_;
   			print "counter 0, account is:".$account."\n";
   		} elsif($counter == 1) {
   			my $clValue = $_;
   			print "counter 1, clValue is:".$clValue."\n";    
   			my $bytes = $clValue->{'bytes'};
   			print "byte is:".$bytes."\n";		
   		}
    	$counter ++;
    }
}
1;