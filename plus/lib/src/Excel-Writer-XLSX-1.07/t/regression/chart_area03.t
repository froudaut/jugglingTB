###############################################################################
#
# Tests the output of Excel::Writer::XLSX against Excel generated files.
#
# Copyright 2000-2020, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_compare_xlsx_files _is_deep_diff);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $filename     = 'chart_area03.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];

my $ignore_elements = {};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();
my $chart     = $workbook->add_chart( type => 'area', embedded => 1, subtype => 'percent_stacked' );

# For testing, copy the randomly generated axis ids in the target xlsx file.
$chart->{_axis_ids} = [ 62813312, 62814848 ];

my $data = [
    [ 1, 2, 3, 4,  5 ],
    [ 8, 7, 6, 8,  10 ],
    [ 3, 6, 9, 12, 15 ],

];

$worksheet->write( 'A1', $data );

$chart->add_series(
    categories => '=Sheet1!$A$1:$A$5',
    values     => '=Sheet1!$B$1:$B$5',
);

$chart->add_series(
    categories => '=Sheet1!$A$1:$A$5',
    values     => '=Sheet1!$C$1:$C$5',
);

$worksheet->insert_chart( 'E9', $chart );

$workbook->close();


###############################################################################
#
# Compare the generated and existing Excel files.
#

my ( $got, $expected, $caption ) = _compare_xlsx_files(

    $got_filename,
    $exp_filename,
    $ignore_members,
    $ignore_elements,
);

_is_deep_diff( $got, $expected, $caption );


###############################################################################
#
# Cleanup.
#
unlink $got_filename;

__END__



