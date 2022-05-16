# Class built for storing RuntimeArgs information
# and handles the change from Json object to RuntimeArgs object
package GetDeploy::ExecutableDeployItem::RuntimeArgs;

use GetDeploy::ExecutableDeployItem::NamedArg;
use JSON;
sub new {
	my $class = shift;
	my $self = {
		_listNamedArg => [ @_ ],
	};
	bless $self, $class;
	return $self;
}

# get-set methods for _listNamedArg
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

# This function turn a Json object to an RuntimeArgs object
sub fromJsonListToRuntimeArgs {
	my @list = @_;
    my @argListJson = @{$list[1]};
    my $totalArgs = @argListJson;
    my @listNamedArg = @_;
    my $counter = 0;
    foreach(@argListJson) {
    	my @oneArg = @{$_};
    	my $jsonOA = encode_json(@oneArg);
    	$counter ++;
    	my $oneNamedArg = GetDeploy::ExecutableDeployItem::NamedArg->fromJsonArrayToNamedArg($_);
    	push(@listNamedArg,$oneNamedArg);
    }
    my $ret = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
    $ret->setListNamedArg(@listNamedArg);
    my $totalNamedArgs = @listNamedArg;
    return $ret;
}
1;