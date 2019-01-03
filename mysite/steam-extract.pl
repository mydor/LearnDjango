#!/usr/bin/perl

use strict;
use Data::Dumper;
use JSON;
use SteamKey;
use Getopt::Long;

my %OPTS = ();

GetOptions(
    \%OPTS,
    '--json:s',
    '--pretty:s'
);

my $json = new JSON;
my @rows = ();

open( IN, '/home/archmage/steam-keys' );
while( defined( my $line = <IN> ) ) {
    $line =~ s!^\s+!!;
    $line =~ s!\s+$!!;
    next unless( $line );

    ##01* Hacknet - 2017/10/18 - Down Under Bundle - https://www.humblebundle.com/download?key=rtwxzZeqWXhKM7Hm - https://www.humblebundle.com/gift?key=fyfpfASHA2KhPMVV (Fred Nugen 2017/11/09)
    my $key = SteamKey->new($line);

    my $data = {
        'model' => 'steamkeys.steamkey',
        'pk' => $key->id(),
        'fields' => {
            'name' => $key->title(),
            'purchase_date' => $key->purchased(),
            'bundle_name' => $key->bundle(),
            'bundle_url' => $key->bundle_url(),
            'given_to' => $key->gifted_to(),
            'given_date' => $key->gifted(),
            'gift_url' => $key->gift_url(),
        },
    };
    push @rows, $data;
#    [{"model": "steamkeys.steamkey", "pk": 1, "fields": {"name": "Hacknet", "purchase_date": "2017-10-18", "bundle_name": "Down Under Bundle", "bundle_url": "https://www.humblebundle.com/download?key=rtwxzZeqWXhKM7Hm", "given_to": "Fred Nugen", "given_date": "2017-11-09", "gift_url": "https://www.humblebundle.com/gift?key=fyfpfASHA2KhPMVV", "created": "2019-01-02T19:21:33.686Z", "modified": "2019-01-02T19:22:39.075Z"}}, {"model": "steamkeys.steamkey", "pk": 2, "fields": {"name": "Day of the Tentacle", "purchase_date": "2017-02-20", "bundle_name": "Freedom Bundle", "bundle_url": "https://www.humblebundle.com/downloads?key=HYyhbh26qpZfeffK", "given_to": null, "given_date": null, "gift_url": "https://www.humblebundle.com/gift?key=dt8ewa4sNMCAvpSs", "created": "2019-01-02T19:32:20.112Z", "modified": "2019-01-02T19:34:02.051Z"}}](LearnDjango) [archmage@linux mysite]$

}
close( IN );

output( $json, \@rows, $json->can('encode'), $OPTS{'json'} ) if( exists $OPTS{'json'} );
output( $json, \@rows, $json->pretty->can('encode'), $OPTS{'pretty'} ) if( exists $OPTS{'pretty'} );

exit 0;

sub output {
    my( $json, $data, $func, $file ) = @_;

    my $fh = \*STDOUT;
    open( $fh, ">$file" ) if( $file && $file ne '-' );
    print $fh $func->( $json, $data );
    close( $fh ) if( $fh != \*STDOUT );
}
