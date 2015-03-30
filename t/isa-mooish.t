use strict;
use warnings;

# de minimus testing

use Test::More;
use Test::Moose::More 0.017;
use Test::Fatal;

use aliased 'Moose::Meta::TypeConstraint'                    => 'TypeConstraint';
use aliased 'MooseX::Meta::TypeConstraint::Mooish'           => 'MooishTC';
use aliased 'MooseX::TraitFor::Meta::TypeConstraint::Mooish' => 'TraitFor';

my $constraint = sub { die if $_[0] ne '5' };

my $tc = MooishTC->new(
    constraint => $constraint,
);

isa_ok $tc, MooishTC;
ok $tc->has_original_constraint => 'has an original constraint';
ok $tc->mooish                  => 'is mooish';

ok  $tc->check(5)      => 'constraint passes with 5';
ok !$tc->check('five') => 'constraint fails with "five"';

my $tc2 = MooishTC->new(
    constraint => $constraint,
);

isa_ok $tc2, MooishTC;
ok $tc2->has_original_constraint => 'has an original constraint';
ok $tc2->mooish                  => 'is mooish';


TODO: {
    local $TODO = 'equality fails ATM';

    cmp_ok $tc, '==', $tc2;
    ok $tc->equals($tc2) => '$tc->equals($tc2)';
    ok $tc2->equals($tc) => '$tc2->equals($tc)';
}

done_testing;
