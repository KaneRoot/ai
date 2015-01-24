package logique;
use v5.10;

use IO::Socket::INET6;
use YAML::XS;
use communication ':all';

use Exporter 'import';
# what we want to export eventually
our @EXPORT_OK = qw/check_game_logic play/;

# bundle of exports (tags)
our %EXPORT_TAGS = ( all => [qw/check_game_logic play/] );

# [gd][ad][hv]
# gauche droit, attaque défense, horizontal vertical
#
#    gdh 0 gah 0 gdv 0 gav 0 
#    ddh 0 dah 0 ddv 0 dav 0 

sub play { # the game logic must be checked before
    my ($p1, $p2, $p1s, $p2s, $setup) = @_;

    $$setup{score_p1}++ if($$p1{gav} && ! $$p2{gdv});
    $$setup{score_p2}++ if($$p2{gav} && ! $$p1{gdv});
    $$setup{score_p1}++ if($$p1{gah} && ! $$p2{ddh});
    $$setup{score_p2}++ if($$p2{gah} && ! $$p1{ddh});

    $$setup{score_p1}++ if($$p1{dav} && ! $$p2{ddv});
    $$setup{score_p2}++ if($$p2{dav} && ! $$p1{ddv});
    $$setup{score_p1}++ if($$p1{dah} && ! $$p2{gdh});
    $$setup{score_p2}++ if($$p2{dah} && ! $$p1{gdh});
}

sub check_game_logic {
    my ($p1, $p2, $p1s, $p2s) = @_;

    # print errors if there is a problem
    unless(is_inputs_ok($p1) && is_inputs_ok($p2)) {

        unless(is_inputs_ok($p1)) {
            say "P1 : Your algo sucks balls";
            send_msg $p1s, {msg => "Your algo sucks balls", BYE => 1};
        }

        unless(is_inputs_ok($p2)) {
            say "P2 : Your algo sucks balls";
            send_msg $p2s, {msg => "Your algo sucks balls", BYE => 1};
        }

        die "Algo issue, end of the game";
    }

    1;
}

sub is_inputs_ok {
    my ($p) = @_;

    !($$p{gdh} == 1 && $$p{gdv} == 1
        || $$p{gah} == 1 && $$p{gav} == 1
        || $$p{dah} == 1 && $$p{dav} == 1
        || $$p{ddh} == 1 && $$p{ddv} == 1);
}

1;
