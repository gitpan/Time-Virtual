#!./perl -w

use Test; BEGIN { plan test => 5 }

use Time::Virtual qw(NVtime U3time);
ok 1;

eval { NVtime };
ok $@, '/implemented/';

eval { U3time };
ok $@, '/implemented/';

Time::Virtual::install(nv => sub {
			   1.5
		       },
		       u3 => sub {
			   use integer;
			   1,2,3
		       });

ok NVtime, 1.5;
ok join ',', U3time, '1,2,3';
