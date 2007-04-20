package DBIx::Class::StorageReadOnly::TT;
use strict;
use warnings;
use base 'DBIx::Class';
use Carp::Clan qw/^DBIx::Class/;

our $VERSION = '0.02';
use DBIx::Class::Storage::DBI;

package DBIx::Class::Storage::DBI;
use tt (subs => [qw/insert update delete/]);
[% FOR sub IN subs %]
    [% IF sub == 'insert' %]
        sub [% sub %] {
            my ($self, $ident, $to_insert) = @_;
            if ($self->_search_readonly_info) {
                croak("This connection is read only. Can't [% sub %].");
            }
            $self->throw_exception(
                "Couldn't insert ".join(', ',
                map "$_ => $to_insert->{$_}", keys %$to_insert
                )." into ${ident}"
            ) unless ($self->_execute([% sub %] => [], $ident, $to_insert));
            return $to_insert;
        }
    [% ELSE %]
        sub [% sub %] {
            my $self = shift;
            if ($self->_search_readonly_info) {
                croak("This connection is read only. Can't [% sub %].");
            }
            return $self->_execute([% sub %] => [], @_);
        }
    [% END %]
[% END %]
no tt;

sub _search_readonly_info {
    my $self = shift;
    for my $info ( @{$self->connect_info} ) {
        if (ref $info eq 'HASH' ) {
            return 1 if $info->{read_only} == 1;
        }
    }
    return;
}

1;
__END__

=head1 NAME

DBIx::Class::StorageReadOnly::TT - Can't insert and update and delete for DBIC and Yappo-san

=head1 For

Yappo-san.

=head1 AUTHOR

Atsushi Kobayashi  C<< <atsushi __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Atsushi Kobayashi C<< <atsushi __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

