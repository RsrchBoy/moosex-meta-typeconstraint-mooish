package MooseX::Meta::TypeConstraint::Mooish;

# ABSTRACT: Translate Moo-style constraints to Moose-style

use Moose;
use namespace::autoclean 0.24;

extends 'Moose::Meta::TypeConstraint';
with 'MooseX::TraitFor::Meta::TypeConstraint::Mooish';

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
!!42;
__END__

=head1 SYNOPSIS

    # easiest is via AttributeShortcuts
    use MooseX::AttributeShortcuts 0.028;

    has foo => (
        is  => 'rw',
        isa => sub { die unless $_[0] == 5 },
    );

    # or, the hard way
    use MooseX::Meta::TypeConstraint::Mooish;

    has foo => (
        is  => 'rw',
        isa => MooseX::Meta::TypeConstraint::Mooish->new(
            constraint => sub { die unless $_[0] == 5 },
        ),
    );

=head1 DESCRIPTION

L<Moose type constraints|Moose::Meta::TypeConstraint> are expected to return
true if the value passes the constraint, and false otherwise; L<Moo>
"constraints", on the other hand, die if validation fails.

This metaclass allows for Moo-style constraints; it will wrap them and
translate their Moo into a dialect Moose understands.

Note that this is largely to enable functionality in
L<MooseX::AttributeShortcuts>; the easiest way use this metaclass is by using
that package.  Also, as it's not inconceivable that this functionality may be
desired in other constraint metaclasses, the bulk of this metaclass'
functionality is implemented as
L<a trait|MooseX::TraitFor::Meta::TypeConstraint::Mooish>.

=head1 SEE ALSO

MooseX::AttributeShortcuts
MooseX::TraitFor::Meta::TypeConstraint::Mooish

=cut
