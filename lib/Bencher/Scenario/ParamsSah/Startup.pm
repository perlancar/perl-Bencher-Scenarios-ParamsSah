package Bencher::Scenario::ParamsSah::Startup;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark startup',
    module_startup => 1,
    participants => [
        {module=>'Params::Sah'},
        {module=>'Type::Params'},
        {module=>'Params::ValidationCompiler'},
    ],
};

1;
# ABSTRACT:
