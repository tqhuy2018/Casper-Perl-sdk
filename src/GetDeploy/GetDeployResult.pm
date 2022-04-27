=comment
This class stored the information of the GetDeployRPC call and encapsulated it 
in the class GetDeployResult
=cut
package GetDeployResult;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		deploy => shift,
		executionResults => shift,
	};
}
1;