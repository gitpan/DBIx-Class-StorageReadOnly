package DBIx::Class::StorageReadOnly;
use strict;
use warnings;
use base 'DBIx::Class';
use Carp::Clan qw/^DBIx::Class/;

our $VERSION = '0.01';

sub insert {
    my $self = shift;

    if ($self->result_source->schema->{__READ_ONLY_CONNECTION}) {
        croak("This connection is read only. Can't insert.");
    }
    $self->next::method(@_);
}

sub update {
    my $self = shift;

    if ($self->result_source->schema->{__READ_ONLY_CONNECTION}) {
        croak("This connection is read only. Can't update.");
    }
    $self->next::method(@_);
}

1;
__END__

=head1 NAME

DBIx::Class::StorageReadOnly - Can't insert and update for DBIC

=head1 SYNOPSIS

    __PACKAGE__->load_components(qw/
        StorageReadOnly
        PK::Auto
        Core
    /);
    
    # create connection
    my $schema = $schema_class->connect(@connection_info);
    # set read only flag.
    $schema->{__READ_ONLY_CONNECTION} = 1;
    
    my $user = $schema->resultset('User')->search({name => 'nomaneko'});
    $user->update({name => 'gikoneko'}); # die. Can't update.

=head1 DESCRIPTION

If you try to write it in read only DB, the exception is generated. 

=head1 METHOD

=head2 insert

set hook point.

=head2 update 

set hook point.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Atsushi Kobayashi  C<< <atsushi __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Atsushi Kobayashi C<< <atsushi __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

