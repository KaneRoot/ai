#!/usr/bin/perl -w
use v5.10;
use Modern::Perl;
use IO::Socket::INET6;
use YAML::XS;

use affichage ':all';
use api ':all';
use logique ':all';
use communication ':all';

our %setup = qw/
    score_p1 0
    score_p2 0
    ipaddress localhost
    portaddress 9000
    protocol tcp
    max_score 30
/;

our $clear = `clear`;
our ($p1s, $p2s, $sock) = wait_for_players { %setup };

sub print_game {
    say $clear;

    my ($player1, $player2) = get_players_choice $p1s, $p2s;
    check_game_logic $player1, $player2, $p1s, $p2s;
    play $player1, $player2, $p1s, $p2s, \%setup;

    print_count $setup{score_p1}, $setup{score_p2};
    print_lines $player1, $player2;

    send_msg $p1s, { 
        score_p1 => $setup{score_p1}
        , score_p2 => $setup{score_p2}
        , opponent => $player2
    };

    send_msg $p2s, { 
        score_p1 => $setup{score_p1}
        , score_p2 => $setup{score_p2}
        , opponent => $player1
    };
}

# do the game
while(1) { 
    print_game; 
    sleep 1;

    if($setup{score_p1} >= $setup{max_score} || $setup{score_p2} >= $setup{max_score}) {

        if($setup{score_p1} > $setup{score_p2}) {
            say "Player 1 wins !!";
            send_msg $p1s, {msg => "Player 1 wins !!", BYE => 1 };
            send_msg $p2s, {msg => "Player 1 wins !!", BYE => 1 };
        }
        elsif($setup{score_p1} == $setup{score_p2}) {
            say "DRAW !!!";
            send_msg $p1s, {msg => "DRAW !!!", BYE => 1 };
            send_msg $p2s, {msg => "DRAW !!!", BYE => 1 };
        }
        else {
            say "Player 2 wins !! ";
            send_msg $p1s, {msg => "Player 2 wins !!", BYE => 1 };
            send_msg $p2s, {msg => "Player 2 wins !!", BYE => 1 };
        }

        exit 0;
    }
}
