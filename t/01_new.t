use strict;
use warnings;
use Test::More tests => 2;
use Geo::Coder::Mapquest;

my $geo = Geo::Coder::Mapquest->new(apikey => 'placeholder');
isa_ok($geo, 'Geo::Coder::Mapquest', 'new');
can_ok('Geo::Coder::Mapquest', qw(geocode ua));
