use 5.006;
use strict;
use warnings;
use Module::Build;
Module::Build->VERSION('0.4004');

my $builder = Module::Build->new(
    module_name         => 'GetStateRootHash::GetStateRootHashRPC',
    license             => 'MIT',
    dist_author         => q{huy tran quang <tqhuy2018@gmail.com>},
    dist_version_from   => 'lib/GetStateRootHash/GetStateRootHashRPC.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => '0.4004',
    },
    test_requires => {
        'Test::More' => '0',
    },
    requires => {

    },
    add_to_cleanup     => [ '.-*' ],
);

$builder->create_build_script();
