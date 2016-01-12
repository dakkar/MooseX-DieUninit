#!perl
use strict;
use warnings;
use 5.020;
use Test::More;
use Test::Deep;
use Test::Fatal;

package Thing {
    use Moose;
    use MooseX::DieUninit;

    has attr1 => ( is => 'ro' );
    has attr2 => ( is => 'ro', default => sub { shift->attr1 + 1 } );
    has attr3 => ( is => 'rw' );
};

my $o;
cmp_deeply(
    exception { $o = Thing->new(attr1=>1) },
    undef,
    'building with values should work',
);
cmp_deeply(
    $o,
    methods(
        attr1 => 1,
        attr2 => 2,
    ),
    'attributes should have expected values',
);
cmp_deeply(
    exception { $o->attr3 },
    all(
        isa('Moose::Exception'),
        isa('MooseX::DieUninit::Exception'),
        methods(
            attribute_name => 'attr3',
            instance => $o,
        ),
    ),
    'accessing an uninitialised attribute via reader should die',
);
cmp_deeply(
    exception { $o->attr3(5) },
    undef,
    'setting attribute should live',
);
my $val3;
cmp_deeply(
    exception { $val3 = $o->attr3 },
    undef,
    'accessing attribute with value, via reader, should live',
);
cmp_deeply(
    $val3,
    5,
    'attribute should have expected value',
);

cmp_deeply(
    exception { Thing->new },
    all(
        isa('Moose::Exception'),
        isa('MooseX::DieUninit::Exception'),
        methods(
            attribute_name => 'attr1',
        ),
    ),
    'building without values should die with correct exception',
);

done_testing;
