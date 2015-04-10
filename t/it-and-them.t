use strict;
use warnings;

# ABSTRACT: Make sure $_ and $_[0] behave identically
#
# Essentially, regression prevention.  Minimal, but should alert us to any
# problems.

use Test::More;
use Test::Moose::More 0.017;
use Test::Fatal;

use aliased 'MooseX::Meta::TypeConstraint::Mooish'           => 'MooishTC';

# I kinda hate subtests at the beginning starting w/o at least one test before
# them...  maybe this tests my brain?
pass 'Ready? go!';

my $_test = sub {
    my ($constraint_sub) = @_;
    
    my $tc = MooishTC->new(
        constraint => $constraint_sub,
    );

    isa_ok $tc, MooishTC;
    ok $tc->has_original_constraint => 'has an original constraint';
    ok $tc->mooish                  => 'is mooish';

    ok  $tc->check(5)      => 'constraint passes with 5';
    ok !$tc->check('five') => 'constraint fails with "five"';
};

subtest 'use: $_' => sub { $_test->(sub { die if $_    ne '5' }) };
subtest 'use: @_' => sub { $_test->(sub { die if $_[0] ne '5' }) };

done_testing;
