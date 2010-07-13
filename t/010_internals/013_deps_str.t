#!perl -w

use strict;
use Test::More;

use Text::Xslate;
use FindBin qw($Bin);
use File::Copy qw(copy move);

use t::lib::Util;

my $base    = path . "/myapp/base.tx";
#my $derived = path . "/myapp/derived.tx";
END{
    move "$base.save" => $base if -e "$base.save";

    unlink $base    . "c";
#    unlink $derived . "c";
}

note 'for strings';

utime $^T-120, $^T-120, $base;

my $tx = Text::Xslate->new(path => [path], cache_dir => path);

#use Data::Dumper; print Dumper $tx;

$tx->load_string(":cascade myapp::base");
is $tx->render(undef, {lang => 'Xslate'}), <<'T';
HEAD
    Hello, Xslate world!
FOOT
T

move $base => "$base.save";
copy "$base.mod" => $base;

utime $^T+60, $^T+60, $base;

$tx->load_string(":cascade myapp::base");
is $tx->render(undef, {lang => 'Foo'}), <<'T';
HEAD
    Modified version of base.tx
FOOT
T

move "$base.save" => $base;
utime $^T+120, $^T+120, $base;

$tx->load_string(":cascade myapp::base");
is $tx->render(undef, {lang => 'Perl'}), <<'T';
HEAD
    Hello, Perl world!
FOOT
T

done_testing;