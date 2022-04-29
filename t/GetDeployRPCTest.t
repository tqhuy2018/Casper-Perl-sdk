#!/usr/bin/env perl

use strict;
use warnings;

use Test::Simple tests => 2;
BEGIN {
  require Config;
  my $can_fork = $Config::Config{d_fork} ||
    (($^O eq 'MSWin32' || $^O eq 'NetWare') and
     $Config::Config{useithreads} and
     $Config::Config{ccflags} =~ /-DPERL_IMPLICIT_SYS/
    );
  if ( $can_fork && !(($^O eq 'MSWin32') && $Devel::Cover::VERSION) ) {
    print "1..8\n";
  } else {
    if ( ($^O eq 'MSWin32') && $Devel::Cover::VERSION ) {
        print "1..0 # Skip Devel::Cover coverage testing is incompatible with fork under 'MSWin32'\n";
    } else {
        print "1..0 # Skip No fork available\n";
    }
    exit;
  }
}

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;
#use GetDeploy::GetDeployRPC;

sub hello_world
{
return "Hello world!";
}

sub get_number
{
return int(rand(1000));
}
ok( hello_world( ) eq "Hello world!", "My Testcase 1" );
ok( get_number( ) > 0, "My Testcase 2" );
