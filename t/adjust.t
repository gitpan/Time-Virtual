#!./perl -w

use Test; plan test => 2;

require Time::Virtual;

my $code = sub {
    ok shift, 1.5;
};

Time::Virtual::subscribe($code);
Time::Virtual::broadcast_adjustment(1.5);
Time::Virtual::unsubscribe($code);

Time::Virtual::broadcast_adjustment(2.5);
ok 1;
