use strict;
package Time::MakeMaker;
use Config;
use base 'Exporter';
use vars qw(@EXPORT_OK);
@EXPORT_OK = qw(&time_virtual_args);

my $installsitearch = $Config{sitearch};
$installsitearch =~ s,$Config{prefix},$ENV{PERL5PREFIX}, if
    exists $ENV{PERL5PREFIX};

sub time_virtual_args {
    my %arg = @_;
    $arg{INC} .= " -I$installsitearch/Time/Virtual";
    %arg;
}

1;
