#!perl

use strict ("subs", "vars", "refs");
use warnings ("all");
BEGIN { $ENV{LIST_MOREUTILS_PP} = 0; }
END { delete $ENV{LIST_MOREUTILS_PP} } # for VMS
use List::MoreUtils (":all");
use lib ("t/lib");


use Test::More;
use Test::LMU;

# Normal cases
my @list = (1 .. 10000);
is_true(notall { !defined } @list);
is_true(notall { $_ < 10000 } @list);
is_false(notall { $_ <= 10000 } @list);
is_false(notall {});

leak_free_ok(
    notall => sub {
        my $ok  = notall { $_ == 5000 } @list;
        my $ok2 = notall { $_ == 5000 } 1 .. 10000;
    }
);
is_dying('notall without sub' => sub { &notall(42, 4711); });

done_testing;


