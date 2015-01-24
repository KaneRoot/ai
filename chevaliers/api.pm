package api;
use v5.10;

use IO::Socket::INET6;
use YAML::XS;
use communication ':all';

use Exporter 'import';
# what we want to export eventually
our @EXPORT_OK = qw/
client_connection 
wait_for_players 
get_players_choice 
/;

# bundle of exports (tags)
our %EXPORT_TAGS = (
    all => [qw/wait_for_players get_players_choice/] 
    , client => [ qw/client_connection/ ]);

# [gd][ad][hv]
# gauche droit, attaque défense, horizontal vertical
#
#    gdh 0 gah 0 gdv 0 gav 0 
#    ddh 0 dah 0 ddv 0 dav 0 

sub wait_for_players {
    my ($setup) = @_;

    my $sock = IO::Socket::INET6->new(Listen => 2
        , LocalAddr => $$setup{ipaddress}
        , LocalPort => $$setup{portaddress}
        , Proto     => $$setup{protocol}
        , ReuseAddr => 1
        , ReusePort => 1) or die "impossible d'init le serveur $@";

    my $p1s = $sock->accept(); 
    my $p2s = $sock->accept(); 

    send_msg $p1s, { msg => "1, O"};
    send_msg $p2s, { msg => "2, X"};

    ($p1s, $p2s, $sock);
}

sub get_players_choice {
    my ($p1s, $p2s) = @_;
    (recv_msg($p1s), recv_msg($p2s));
}

sub client_connection {

    my ($setup) = @_;
    my $sock = IO::Socket::INET6->new(
        PeerAddr => $$setup{ipaddress}
        , PeerPort => $$setup{portaddress}
        , Proto     => $$setup{protocol}
        , ReuseAddr => 1
        , ReusePort => 1) or die "impossible d'init le serveur $@";

    $sock;
}


1;
