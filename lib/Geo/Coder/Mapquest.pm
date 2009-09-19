package Geo::Coder::Mapquest;

use strict;
use warnings;

use Carp qw(croak);
use JSON;
use LWP::UserAgent;
use URI;
use URI::Escape qw(uri_unescape);

our $VERSION = '0.01';

sub new {
    my ($class, %params) = @_;

    my $key = $params{apikey} or croak q('apikey' is required);

    my $self = bless {
        key => uri_unescape($key),
    }, $class;

    if ($params{ua}) {
        $self->ua($params{ua});
    }
    else {
        $self->{ua} = LWP::UserAgent->new(agent => "$class/$VERSION");
    }

    return $self;
}

sub ua {
    my ($self, $ua) = @_;
    if ($ua) {
        croak q('ua' must be (or derived from) an LWP::UserAgent')
            unless ref $ua and $ua->isa(q(LWP::UserAgent));
        $self->{ua} = $ua;
    }
    return $self->{ua};
}

sub geocode {
    my $self = shift;

    my $location = @_ % 2 ? $_[0] : $_[0] eq 'location' ? $_[1] : '';
    return unless $location;

    my $uri = URI->new(
        'http://platform.beta.mapquest.com/geocoding/v1/address'
    );
    $uri->query_form(key => $self->{key}, location => $location);

    my $res = $self->ua->get($uri);
    return unless $res->is_success;

    my $data = eval { decode_json($res->decoded_content) };
    return unless $data;

    my @results = @{ $data->{locations} || [] };
    return wantarray ? @results : $results[0];
}


1;

__END__

=head1 NAME

Geo::Coder::Mapquest - Geocode addresses with Mapquest (beta)

=head1 SYNOPSIS

    use Geo::Coder::Mapquest;

    my $geocoder = Geo::Coder::Mapquest->new(apikey => 'Your API Key');
    my $location = $geocoder->geocode(
        location => 'Hollywood and Highland, Los Angeles, CA'
    );

=head1 DESCRIPTION

The C<Geo::Coder::Mapquest> module provides an interface to the Beta
Mapquest Geocoding Web Service.

=head1 METHODS

=head2 new

    $geocoder = Geo::Coder::Mapquest->new(apikey => 'Your API Key')

Creates a new geocoding object.

A valid developer 'apikey' is required. See L</NOTES> on how to obtain one
and set it up.

Accepts an optional B<ua> parameter for passing in a custom LWP::UserAgent
object.

=head2 geocode

    $location = $geocoder->geocode(location => $location)
    @locations = $geocoder->geocode(location => $location)

In scalar context, this method returns the first location result; and in list
context it returns all locations results.

Each location result is a hashref; a typical example looks like:

   {
        adminArea1         => "US",
        adminArea1Type     => "Country",
        adminArea3         => "CA",
        adminArea3Type     => "State",
        adminArea4         => "Los Angeles County",
        adminArea4Type     => "County",
        adminArea5         => "Los Angeles",
        adminArea5Type     => "City",
        displayLatLng      => { lat => "34.10155", lng => "-118.33869" },
        dragPoint          => 0,
        geocodeQuality     => "INTERSECTION",
        geocodeQualityCode => "I1BAA",
        latLng             => { lat => "34.10155", lng => "-118.33869" },
        linkId             => 0,
        postalCode         => 90028,
        sideOfStreet       => "N",
        street             => "Hollywood Blvd & N Highland Ave",
        type               => "s",
    }

=head2 ua

    $ua = $geocoder->ua()
    $ua = $geocoder->ua($ua)

Accessor for the UserAgent object.

=head1 NOTES

The geocoding results are not production quality at this time. International
queries produce no results and US addresses frequently only return results
that are only accurate to the country-level.

An API key can be obtained here:
L<http://developer.mapquest.com/Home/WhyJoin>.

Note that Mapquest already url-encodes the key, so the geocoder constructor
will prevent it from being doubly-encoded. Ensure you do not decode it
yourself before passing it to the constructor.

After obtaining a key, you must enable the I<Blank Referers> option for the
account.

=head1 SEE ALSO

L<http://platform.beta.mapquest.com/geocoding/>

L<Geo::Coder::Bing>, L<Geo::Coder::Google>, L<Geo::Coder::Yahoo>

=head1 REQUESTS AND BUGS

Please report any bugs or feature requests to
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Geo-Coder-Mapquest>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::Coder::Mapquest

You can also look for information at:

=over

=item * GitHub Source Repository

L<http://github.com/gray/geo-coder-mapquest>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-Coder-Mapquest>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-Coder-Mapquest>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=Geo-Coder-Mapquest>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-Coder-Mapquest>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 gray <gray at cpan.org>, all rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

gray, <gray at cpan.org>

=cut
