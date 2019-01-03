package SteamKey;

use strict;

our $redate = '\d{4}(?:[/-]\d{1,2}){2}';

sub new {
    my( $class, $line ) = @_;

    my @data = split( /\s+-\s+/, $line );
    my $self = bless {
        'data' => {},
        'line' => $line,
        'fields' => \@data,
    }, $class;

    # Stript the gift_url from the last field
    $self->{'fields'}[-1] =~ s!\s*http\S+\s*!!;

    return $self;
}

sub _set {
    my( $self, $key, $val ) = @_;

    return undef unless( defined $val );

    $self->{'data'}{$key} = $val;

    return $val;
}

sub _get {
    my( $self, $key ) = @_;

    return $self->{'data'}{$key} if( exists $self->{'data'}{$key} and defined $self->{'data'}{$key} );

    return undef;
}

sub id {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'id', $val ) );

    my $cache = $self->_get( 'id' );
    return $cache if( defined $cache );

    my( $id ) = $self->{'line'} =~ /^(\d+)/;
    return $self->_set( 'id', int($id) );
}

sub get_date {
    my( $self, $pos ) = @_;

    #my $redate = '\d{4}(?:[/-]\d{1,2}){2}';
                                    #/^(?:.*?\K(${redate})){2}/
    my( $date ) = $self->{'line'} =~ /^(?:.*?\K(${redate})){${pos}}/;

    # Replace / with -
    $date =~ s|/|-|g;

    return $date;
}

sub purchased {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'purchased', $val ) );

    my $cache = $self->_get( 'purchased' );
    return $cache if( defined $cache );

    my $date = $self->get_date(1);
    return $self->_set( 'purchased', $date );
}

sub gifted_to {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'to', $val ) );

    my $cache = $self->_get( 'to' );
    return $cache if( defined $cache );

    my $extra = $self->{'fields'}[-1];

    # Strip any decorators
    $extra =~ s!^\s*\(\s*!!;
    $extra =~ s!\s*\)\s*$!!;

    # Strip the date
    $extra =~ s!\s*${redate}\s*!!;

    return $self->_set( 'to', $extra );
}

sub gifted {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'gifted', $val ) );

    my $cache = $self->_get( 'gifted' );
    return $cache if( defined $cache );

    my $date = $self->get_date(2);
    return $self->_set( 'gifted', $date );
}

sub get_url {
    my( $self, $id ) = @_;

    my( $url ) = $self->{'line'} =~ /(http\S+${id}\?key=\S+)/;

    return $url;
}

sub bundle_url {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'bundle_url', $val ) );

    my $url = $self->get_url( 'downloads' );
    return $self->_set( 'bundle_url', $url );
}

sub gift_url {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'gift_url', $val ) );

    my $url = $self->get_url( 'gift' );
    return $self->_set( 'gift_url', $url );
}

sub title {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'title', $val ) );

    my $cache = $self->_get( 'bundle' );
    return $cache if( defined $cache );

    my $title = substr($self->{'fields'}[0], 4);
    return $self->_set( 'title', $title );
}

sub bundle {
    my( $self, $val ) = @_;

    return if( defined $self->_set( 'bundle', $val ) );

    my $cache = $self->_get( 'bundle' );
    return $cache if( defined $cache );

    my $bundle = $self->{'fields'}[2];
    return $self->_set( 'bundle', $bundle );
}

1;
