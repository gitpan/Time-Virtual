use strict;
package Time::Virtual;
require DynaLoader;
use base ('Exporter','DynaLoader');
use vars qw($VERSION @EXPORT_OK %AdjustCB $API);
$VERSION = '0.02';
@EXPORT_OK = qw(NVtime U3time);

__PACKAGE__->bootstrap($VERSION);

# XS: install XXX

sub broadcast_adjustment {
    my ($adj) = @_;
    for my $x (values %AdjustCB) { $x->($adj) }
}

sub subscribe {
    my ($code) = @_;
    $AdjustCB{0+$code} = $code;
}

sub unsubscribe {
    my ($code) = @_;
    delete $AdjustCB{0+$code};
}

1;
=head1 NAME

Time::Virtual - Publish high-precision time or custom implementations of time

=head1 SYNOPSIS

  require Time::Virtual;

  # XXX add example

=head1 DESCRIPTION

This module provides a mechanism to insert a level of indirection
between the actually hardware-level time and the time as seen by the
current process.

Effort is made to avoid any assumptions about how time is represented
and what is the available precision.

There is also a C-API available in order to allow customizing the
passage of time.  (Speed up, slow down, time travel, etc.)

=head1 SUPPORT

This extension is discussed on the perl-loop@perl.org mailing list.

=head1 ALSO SEE

L<Time::HiRes> and L<Event>

=head1 AUTHOR

Joshua N. Pritikin E<lt>F<bitset@mindspring.com>E<gt>

=head1 COPYRIGHT

Copyright © 1998 Joshua Nathaniel Pritikin.  All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
