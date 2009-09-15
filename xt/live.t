use strict;
use warnings;
use Encode;
use Geo::Coder::Mapquest;
use Test::More tests => 2;

unless ($ENV{MAPQUEST_APIKEY}) {
    plan skip_all => 'MAPQUEST_APIKEY environment variable must be set';
}

my $geocoder = Geo::Coder::Mapquest->new(apikey => $ENV{MAPQUEST_APIKEY});
{
    my $address = 'Hollywood & Highland, Los Angeles, CA';
    my $location = $geocoder->geocode($address);
    is($location->{postalCode}, 90028, "correct zip code for $address");
}
TODO: {
    local $TODO = 'Multiple locations';
    my @locations = $geocoder->geocode('Main Street');
    ok(@locations > 1, 'there are many Main Streets');
}
