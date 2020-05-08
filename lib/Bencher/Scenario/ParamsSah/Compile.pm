package Bencher::Scenario::ParamsSah::Compile;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Measure compilation speed',
    participants => [
        {
            name => 'Params::Sah',
            fcall_template => q(Params::Sah::gen_validator("int*", ["array*",of=>"int*"])),
        },
        {
            name => 'Type::Params',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Int ArrayRef); compile(Int, ArrayRef[Int])),
        },
        {
            name => 'Params::ValidationCompiler',
            module => 'Params::ValidationCompiler',
            code_template => q(use Params::ValidationCompiler qw(validation_for); use Types::Standard qw(Int ArrayRef); validation_for(params => [{type=>Int}, {type=>ArrayRef[Int]}])),
        },
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

Compilation of L<Sah> schemas by L<Data::Sah> (which is used by L<Params::Sah>)
is slower due to doing more stuffs like normalizing schema and other
preparations. If needed, future version of Params::Sah or Data::Sah can cache
compilation result particularly for commonly encountered simple schemas like
C<'int'>, C<< ['array*', of=>'str*'] >>, etc.
