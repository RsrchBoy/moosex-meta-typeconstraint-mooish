package MooseX::TraitFor::Meta::TypeConstraint::Mooish;

# ABSTRACT: Handle Moo-style constraints

use Moose::Role;
use namespace::autoclean 0.24;
use Try::Tiny;

=attr original_constraint

The original constraint CodeRef is stashed away here.

=method original_constraint()

Reader for the L</original_constraint> attribute; returns the original
constraint as passed to new().

=method has_original_constraint()

Predicate for the L</original_constraint> attribute.

=cut

has original_constraint => (
    is        => 'ro',
    isa       => 'CodeRef',
    writer    => '_set_original_constraint',
    predicate => 'has_original_constraint',
);

=attr mooish

If true, the constraint should be considered written in the style of L<Moo> constraints; that is, if an exception is thrown the
constraint is considered to have failed; otherwise it passes.  Return values are ignored.

Default is true.

=method mooish()

Reader for the L</mooish> attribute.

=cut

has mooish => (
    is      => 'ro',
    isa     => 'Bool',
    default => 1,
);

=method compile_type_constraint

If L</mooish> is true, we wrap the L</original_constraint> in a sub that translates L<Moo> behaviors
(die on fail; otherwise success) to L<Moose::Meta::TypeConstraint> expectations (false on fail; true on success).

We stash the original constraint in L</original_constraint> (surprise!),
and set the L<constraint attribute|Moose::Meta::TypeConstraint/constraint> to
the wrapped constraint.

=cut

before compile_type_constraint => sub {
    my $self = shift @_;

    ### only wrap our given constraint iff we're supposed to be mooish...
    return unless $self->mooish;

    ### wrap our type constraint, and set it...
    my $wrapped_constraint = $self->_wrap_constraint($self->constraint);
    $self->_set_original_constraint($self->constraint);
    $self->_set_constraint($wrapped_constraint);

    return;
};

sub _wrap_constraint {
    my ($self, $constraint) = @_;

    # call the original constraint.  if it does not die, return true; if it
    # does die, return false.  We might do something with the fail message
    # down the road, but not right now.

    return sub {
        my @args = @_;
        my $fail_msg = try {
            local $_ = $args[0];
            $constraint->(@args);
            return;
        }
        catch {
            return $_;
        };

        return !$fail_msg;
    };
}

=method create_child_type

Subtypes created here are not mooish, unless an explicit C<mooish => 1> is
passed.

=cut

around create_child_type => sub {
    my ($orig, $self) = (shift, shift);

    return $self->$orig(mooish => 0, @_);
};

!!42;
__END__

=pod

=for :stopwords mooish

=head1 DESCRIPTION

    # determining where this goes is left as an exercise for the reader
    with 'MooseX::TraitFor::Meta::TypeConstraint::Mooish';

=head1 SYNOPSIS

This trait implements the functionality described in
L<MooseX::Meta::TypeConstraint::Mooish>, and you, dear reader, are encouraged
to read about it over there.  Here we simply document the nuts and bolts.

=head1 SEE ALSO

MooseX::Meta::TypeConstraint::Mooish

=cut
