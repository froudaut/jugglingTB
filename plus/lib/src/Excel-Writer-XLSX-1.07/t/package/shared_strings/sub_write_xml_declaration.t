###############################################################################
#
# Tests for Excel::Writer::XLSX::Package::SharedStrings methods.
#
# Copyright 2000-2020, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_new_object);
use strict;
use warnings;
use Excel::Writer::XLSX::Package::SharedStrings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $caption;
my $got;
my $obj = _new_object( \$got, 'Excel::Writer::XLSX::Package::SharedStrings' );


###############################################################################
#
# Test the xml_declaration() method.
#
$caption  = " \tSharedStrings: xml_declaration()";
$expected = qq(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n);

$obj->xml_declaration();

is( $got, $expected, $caption );

__END__


