use ExtUtils::MakeMaker;
WriteMakefile(
	      PREREQ_PM => { Test => 1, },
	      NAME => 'Time::Virtual',
	      VERSION_FROM => './lib/Time/Virtual.pm',
	      INC => '-I./lib/Time/Virtual',
	      H => ['lib/Time/Virtual/TimeVirtualAPI.h'],
);
