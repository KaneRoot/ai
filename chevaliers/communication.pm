package communication;
use v5.10;

use IO::Socket::INET6;
use YAML::XS;

use Exporter 'import';
# what we want to export eventually
our @EXPORT_OK = qw/send_msg recv_msg/;

# bundle of exports (tags)
our %EXPORT_TAGS = (all => [qw/send_msg recv_msg/] );

sub send_msg {
    my ($ps, $hrefmsg) = @_;
    say $ps Dump($hrefmsg);
    say $ps "END";
}

sub recv_msg {
    my $p = shift;

    my $yaml = '';

    while(<$p>) {
        last if /END/;
        $yaml .= $_;
    }

    Load($yaml);
}

1;
