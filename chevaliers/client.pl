#!/usr/bin/perl -w

package client;
use v5.14;
use YAML::XS;
use autodie;
use Modern::Perl;

use FindBin qw($Bin);
use lib "$Bin/.";

use affichage ':all';
use api ':client';
use communication ':all';

our %setup = qw/
    score_p1 0
    score_p2 0
    ipaddress localhost
    portaddress 9000
    protocol tcp
/;

my $sock = client_connection { %setup };

my %player = qw/
gdh 1 gah 1 gdv 0 gav 0 
ddh 0 dah 1 ddv 1 dav 0 
/;

while(1) {

    # I receive what the opponent played last time
    # but I don't do anything because it's a dumb algo
    my $response = recv_msg $sock;
    say $$response{msg} if $$response{msg};
    last if $$response{BYE};

    send_msg $sock, { %player };
    sleep 1;
}
