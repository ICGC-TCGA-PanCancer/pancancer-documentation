#!/usr/bin/perl
# File: get_spreadsheets.pl by Marc Perry
# Edit: original file get_spreadsheets.pl, changed by Joseph Lugo
#
# Concept: I would like to create a command line tool
# that will let me quickly download a GDocs spreadsheet
#
# Last Updated: 2014-05-14, Status: basic functionality working

use strict;
use warnings;
use Net::Google::Spreadsheets;
use DateTime;
use DateTime::Duration;
use Getopt::Long;
use Data::Dumper;
use Carp qw( verbose );

# globally overriding calls to die, and sending them to Carp
$SIG{__DIE__} = sub { &Carp::confess };

my $username = q{};
my $password = q{};

my @real_header = ('Project code','Lead Jurisdiction','Tumour Type','GNOS','Pledged Number of WGS T/N Pairs','Number of WGS T/N Pairs They are Tracking','Number of Specimens','Number of Specimens Uploaded','Percent Uploaded','Uploaded T/N Pairs of Specimens','');
my @header = ('projectcode','leadjurisdiction','tumourtype','gnos','pledgednumberofwgstnpairs','numberofwgstnpairstheyaretracking','numberofspecimens','numberofspecimensuploaded','percentuploaded','uploadedtnpairsofspecimens','');

 my %projects = ( 'Pancan-UP' => { key => '0AnBqxOn9BY8ldE5RUk5WX09hV1k4MllOVDdBMFFRNWc',
                                   title => 'ICGC',
                                 },
);

my @now = localtime();
my $timestamp = sprintf("%04d_%02d_%02d_%02d%02d", $now[5]+1900, $now[4]+1, $now[3], $now[2], $now[1]);

# Create a new Net::Google::Spreadsheets object:
my $service = Net::Google::Spreadsheets->new(
    username => "<GMAIL ADDRESS>",
    password => "<GMAIL PASSWORD>",
);

# iterate over the project codes in the %projects hash
foreach my $proj ( keys %projects ) {
    # request the GoogleDocs spreadsheet corresponding
    # to the current key => value pair
    my $spreadsheet;
    unless( $spreadsheet = $service->spreadsheet( {
        key => "$projects{$proj}->{key}",
    } ) )
    {print STDERR "Could not create a \$spreadsheet object for project $proj\n"; next; }  

    # Each GoogleDocs spreadsheet contains one or more worksheets
    my @ws = $spreadsheet->worksheets;

    # iterate over the list of worksheet objects:
    # foreach my $ws ( @ws ) {
        # print out the title of each worksheet in this spreadsheet
        # print STDERR "Worksheet title: ", $ws->title(), "\n";
    # } 

    # iterate over the list of worksheet objects
    foreach my $worksheet ( @ws ) {
        # just pick the one worksheet that matches the desired
        # worksheet title
        if ( $worksheet->title() eq $projects{$proj}->{title} ) {
            print STDERR "Processing the worksheet for project: $proj\n";
            # create an array where each array element contains the fields of a separate row in the worksheet
            my @rows = $worksheet->rows;
            # create a filehandle for printing the output
            open my ($FH), '>', $proj . '_sheet1_'. $timestamp . '.txt' or die "Could not open file for writing: $!";

            # print out the "Real" header row first
            print $FH join("\t", @real_header), "\n";
            foreach my $row ( @rows ) {
                #print "\n", Data::Dumper->new([\$spreadsheet],[qw(spreadsheet)])>Quotekeys(0)->Dump, "\n"
                # this method call returns a hashref:
                my $content = $row->content();
                # here using a hash slice on the dereferenced hashref
                # to extract the values
                my @values = @{$content}{@header};
                # there may be lots of blank rows at the bottom that
                # iwe don't want to print
		my $test = join " ", @values;
                next if $values[0] =~ m/^(''|\#N\/A)/;
		#next if $values[8] =~ /\#N\/A)/;
                print $FH join("\t", @values), "\n";
            } # close inner foreach loop
            close $FH;
        }
        else {
            next;
        } # close if/else test
    } # close foreach loop
} # close outer foreach loop

# print "\n", Data::Dumper->new([\$spreadsheet],[qw(spreadsheet)])->Indent(1)->Quotekeys(0)->Dump, "\n";

exit;
