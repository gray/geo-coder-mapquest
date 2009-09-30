use strict;
use warnings;
use Encode qw(decode encode);
use Geo::Coder::Mapquest;
use Test::More;

unless ($ENV{MAPQUEST_APIKEY}) {
    plan skip_all => 'MAPQUEST_APIKEY environment variable must be set';
}
else {
    plan tests => 8;
}

my $geocoder = Geo::Coder::Mapquest->new(apikey => $ENV{MAPQUEST_APIKEY});
{
    my $address = 'Hollywood & Highland, Los Angeles, CA';
    my $location = $geocoder->geocode($address);
    is($location->{postalCode}, 90028, "correct zip code for $address");
}
{
    my @locations = $geocoder->geocode('Main Street, Los Angeles, CA');
    ok(@locations > 1, 'there are many Main Streets in Los Angeles, CA');
}
TODO: {
    local $TODO = 'International locations';
    my $address = qq(Ch\xE2teau d Uss\xE9, 37420);

    my $location = $geocoder->geocode($address, country => 'FR');
    ok($location, 'latin1 bytes');
    is($location->{adminArea1}, 'FR', 'latin1 bytes');

    $location = $geocoder->geocode(decode('latin1', $address), country => 'FR');
    ok($location, 'UTF-8 characters');
    is($location->{adminArea1}, 'FR', 'UTF-8 characters');

    $location = $geocoder->geocode(
        encode('utf-8', decode('latin1', $address)), country => 'FR',
    );
    ok($location, 'UTF-8 bytes');
    is($location->{adminArea1}, 'FR', 'UTF-8 bytes');
}

