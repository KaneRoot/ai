package affichage;
use v5.10;

use Exporter 'import';
# what we want to export eventually
our @EXPORT_OK = qw/print_count pre_print print_lines/;

# bundle of exports (tags)
our %EXPORT_TAGS = (all => [qw/print_count pre_print print_lines/] );

sub print_count {
    my ($p1, $p2) = @_;
    say "$p1 - $p2";
}

sub pre_print {
    my ($player) = @_;
    my $p = {};

    for(keys %$player) {
        if(! $$player{$_}) { $p->{$_} = ' '; } 
        elsif($_ =~ /a[hv]$/) { $p->{$_} = 'a'; }
        elsif($_ =~ /d[hv]$/) { $p->{$_} = 'd'; }
    }

    $p
}

sub print_lines {
    my ($p_1, $p_2) = @_;

    my $p1 = pre_print $p_1;
    my $p2 = pre_print $p_2;

    say "| O $p1->{gdh} $p1->{gah} $p2->{dah} $p2->{ddh} X |";
    say "| $p1->{gdv}         $p2->{ddv} |";
    say "| $p1->{gav}         $p2->{dav} |";
    say "| $p2->{gav}         $p1->{dav} |";
    say "| $p2->{gdv}         $p1->{ddv} |";
    say "| X $p2->{gdh} $p2->{gah} $p1->{dah} $p1->{ddh} O |";
}

1;
