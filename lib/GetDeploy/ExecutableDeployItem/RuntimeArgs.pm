package GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_listNamedArg => [ @_ ],
	};
	bless $class, $self;
	return $self;
}

#get-set methods for _listNamedArg

sub setListNamedArg {
	my ( $self, @listNamedArg) = @_;
	$self->{_listNamedArg} = \@listNamedArg;
	return $self->{_listNamedArg};
}

sub getListNamedArg {
	my ( $self ) = @_;
	my @listNamedArg = @{ $self->{_listNamedArg} };
	wantarray ? @listNamedArg :\@listNamedArg;
}

sub fromJsonListToRuntimeArgs {
	my @list = @_;
	print "\nparameter in get deploy RuntimeArgs str is:".$list[1]."\n";
    print "about to parse the json to get deploy RuntimeArgs";
}
1;