use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
    NAME          => 'Geo::Coder::Mapquest',
    AUTHOR        => 'gray <gray@cpan.org>',
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Geo/Coder/Mapquest.pm',
    ABSTRACT_FROM => 'lib/Geo/Coder/Mapquest.pm',
    PREREQ_PM     => {
        'JSON'           => 2.0,
        'LWP::UserAgent' => 0,
        'Test::More'     => 0,
        'URI'            => 1.36,
    },
    META_MERGE    => {
        resources  => {
            repository => 'http://github.com/gray/geo-coder-mapquest',
        },
        recommends => {
            'JSON::XS' => 2.0,
        },
    },
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Geo-Coder-Mapquest-*' },
);

unless (eval { ExtUtils::MakeMaker->VERSION(6.46) }) {
    delete $conf{META_MERGE};
}

WriteMakefile(%conf);
