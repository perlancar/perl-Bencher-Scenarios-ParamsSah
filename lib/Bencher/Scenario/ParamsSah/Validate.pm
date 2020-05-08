package Bencher::Scenario::ParamsSah::Validate;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Measure validation speed',
    participants => [
        {
            name => 'Params::Sah-int',
            module => 'Params::Sah',
            code_template => q(state $validator = Params::Sah::gen_validator("int*"); $validator->(<args>)),
            tags => ['int'],
        },
        {
            name => 'Type::Params-int',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Int); state $validator = compile(Int); $validator->(@{<args>})),
            tags => ['int'],
        },
        {
            name => 'Params::ValidationCompiler-int',
            module => 'Params::ValidationCompiler',
            code_template => q(use Params::ValidationCompiler qw(validation_for); use Types::Standard qw(Int); state $validator = validation_for(params => [{type=>Int}]); $validator->(@{<args>})),
            tags => ['int'],
        },

        {
            name => 'Params::Sah-int_int[]',
            module => 'Params::Sah',
            code_template => q(state $validator = Params::Sah::gen_validator("int*", ["array*",of=>"int*"]); $validator->(<args>)),
            tags => ['int_int[]'],
        },
        {
            name => 'Type::Params-int_int[]',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Int ArrayRef); state $validator = compile(Int, ArrayRef[Int]); $validator->(@{<args>})),
            tags => ['int_int[]'],
        },
        {
            name => 'Params::ValidationCompiler-int_int[]',
            module => 'Params::ValidationCompiler',
            code_template => q(use Params::ValidationCompiler qw(validation_for); use Types::Standard qw(Int ArrayRef); state $validator = validation_for(params => [{type=>Int},{type=>ArrayRef[Int]}]); $validator->(@{<args>})),
            tags => ['int_int[]'],
        },

        {
            name => 'Params::Sah-str[]',
            module => 'Params::Sah',
            code_template => q(state $validator = Params::Sah::gen_validator(["array*",of=>"str*"]); $validator->(<args>)),
            tags => ['str[]'],
        },
        {
            name => 'Type::Params-str[]',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Str ArrayRef); state $validator = compile(ArrayRef[Str]); $validator->(@{<args>})),
            tags => ['str[]'],
        },
        {
            name => 'Params::ValidationCompiler-str[]',
            module => 'Params::ValidationCompiler',
            code_template => q(use Params::ValidationCompiler qw(validation_for); use Types::Standard qw(Str ArrayRef); state $validator = validation_for(params => [{type=>ArrayRef[Str]}]); $validator->(@{<args>})),
            tags => ['str[]'],
        },

        {
            name => 'Params::Sah-strwithlen',
            module => 'Params::Sah',
            code_template => q(state $validator = Params::Sah::gen_validator(["str*",min_len=>4, max_len=>8]); $validator->(<args>)),
            tags => ['str'],
        },
        {
            name => 'Type::Params-strwithlen',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Str); state $validator = compile(Str->where('length($_) >= 4 && length($_) <= 8')); $validator->(@{<args>})),
            tags => ['str'],
        },

        {
            name => 'Params::Sah-strwithlen[]',
            module => 'Params::Sah',
            code_template => q(state $validator = Params::Sah::gen_validator(['array*', of=>["str*",min_len=>4, max_len=>8]]); $validator->(<args>)),
            tags => ['strwithlen[]'],
        },
        {
            name => 'Type::Params-strwithlen[]',
            module => 'Type::Params',
            code_template => q(use Type::Params qw(compile); use Types::Standard qw(Str ArrayRef); state $validator = compile(ArrayRef[Str->where('length($_) >= 4 && length($_) <= 8')]); $validator->(@{<args>})),
            tags => ['strwithlen[]'],
        },
    ],
    datasets => [
        {
            name => '1',
            args => { args => [1] },
            include_participant_tags => ['int'],
        },
        {
            name => '1,[]',
            args => { args => [1,[]] },
            include_participant_tags => ['int_int[]'],
        },
        {
            name => '1,[1..10]',
            args => { args => [1,[1..10]] },
            include_participant_tags => ['int_int[]'],
        },
        {
            name => '1,[1..100]',
            args => { args => [1,[1..100]] },
            include_participant_tags => ['int_int[]'],
        },

        {
            name => '[]',
            args => { args => [[]] },
            include_participant_tags => ['str[]'],
        },
        {
            name => '[("a") x 10]',
            args => { args => [[('a')x10]] },
            include_participant_tags => ['str[]'],
        },
        {
            name => '[("a")x100]',
            args => { args => [[('a')x100]] },
            include_participant_tags => ['str[]'],
        },
        {
            name => 'str-foobar',
            args => { args => ['foobar'] },
            include_participant_tags => ['str'],
        },
        {
            name => '[(foobar)x10]',
            args => { args => [[('foobar')x10]] },
            include_participant_tags => ['strwithlen[]'],
        },
        {
            name => '[(foobar)x100]',
            args => { args => [[('foobar')x100]] },
            include_participant_tags => ['strwithlen[]'],
        },
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

=head2 Seeing generated source code

To see the source code generated by Params:Sah, set $Params::Sah::DEBUG to 1. Or
you can try on the command-line (the CLI utility is part of L<App::SahUtils>):

 % validate-with-sah '"int*"' -c

To see the source code generated by Type::Params, pass C<< want_source => 1 >>
option to C<compile()>, e.g.:

 compile({want_source=>1}, Int, ...)

To see the source code generated by Params::ValidationCompiler, pass C<<
debug => 1 >> parameter to C<validation_for()>, e.g.:

 validation_for(params => ..., debug=>1)

=head2 Performance of Params::Sah-generated validation code

Data::Sah has not been optimized to check for simple types like C<int> or <str>
and arrays of those simple types. Compare the generated source code for Sah
schema C<< ['array*',of=>'int*'] >> with Type::Params' code for ArrayRef[Int],
for example.

However, Params::Sah is comparable with Types::Params and
Params::ValidationCompiler once you add clauses like length, etc.
