#!/usr/bin/perl

# Script to illustrate how to parse a simple XML file
# and dump its contents in a Perl hash record.
# This program was made to parse the XML files coming from the workflow_decider.pl and making the 
# usable for certain visualizations.

use strict;
use Getopt::Long;
use XML::Simple;
use Data::Dumper;
use JSON qw( decode_json );

my $json;
my $file;
my $repo;

if (scalar(@ARGV) != 4) { die "USAGE: test_parse.pl --file <XML FILE> --repo <GNOS REPO>"; }

GetOptions ("file=s" => \$file, "repo=s" => \$repo);
#print $repo;

# Parsing XMl and turning into a big hash
my $booklist = XMLin("/home/ubuntu/gitroot/pancancer-info/pancan-scripts/gtrepo-${repo}/xml/${file}");
# Getting all the analysis attribut TAGS
my @attr = @{$booklist->{Result}->{analysis_xml}->{ANALYSIS_SET}->{ANALYSIS}->{ANALYSIS_ATTRIBUTES}->{ANALYSIS_ATTRIBUTE}};

# Print date and aliquot_id
print "$booklist->{date},";
print "$booklist->{Result}->{aliquot_id},";

my $check = 0;
my $i;
my @str;
my $countme;

# Find everything before the qc metrics in this exact order
foreach my $thing ('dcc_project_code','dcc_specimen_type','submitter_donor_id','submitter_sample_id','submitter_specimen_id','total_lanes','use_cntl','qc_metrics'){
$check = 0;

# Checking if TAG matches $thing 
for ($i = 0; $i < scalar @attr; $i++){
# If match then make sure that it is not a hash value and print the value
if ($attr[$i]->{TAG} eq $thing && $thing ne 'qc_metrics'){
        if (ref($attr[$i]->{VALUE}) ne "HASH"){
                $check ++;
                if($check == 1){
                print "$attr[$i]->{VALUE},";
                push (@str, $attr[$i]->{VALUE});
                }}
#        else {print ",";}
}

# When it gets to qc_metrics then we need to print all of the metrics
elsif ($attr[$i]->{TAG} eq $thing && $thing eq 'qc_metrics'){
        # Declare json with the qc_metrics
        $json = $attr[$i]->{VALUE};
        my $decoded = decode_json($json);
        my @ary = @{$decoded->{'qc_metrics'}};
        # If array length is zero then no qc metrics and just print commas as empty fields
        if (scalar @ary == 0){print ",,,,,,,,,,,,,,,,,,,,,,,,,,,\n";}
        # Only print one set of qc_metrics so we print the first one. Some xml's contain dupliacte qc_metrics
        elsif($countme == 0){
        for (my $l=0;$l < scalar @ary;$l++){
                # Only print this if it is not the first run through the qc_metrics
                if ($l != 0){
                        print "$booklist->{date},";
                        print "$booklist->{Result}->{aliquot_id},";
                        my $check = index($str[0],"US");
                        if ($repo eq "cghub"){
                        for (my $o; $o < scalar @str;$o++){
                                # str is the line broken up by commas
                                if($o == 5){print ",$str[5],";}
                                else{print "$str[$o],";}}
                        }
                        elsif(index($str[0],"ESAD-UK") != -1){
                        for (my $o; $o < scalar @str;$o++){
                                if ($o == 2){print ",$str[2],,";}
                                else{print "$str[$o],";}}
                        }
                        else{
                        for (my $o; $o < scalar @str;$o++){
                        print "$str[$o],";
                        }}
                        }
                        #print ",";
                        #print "$str[scalar @str -1],";}
                        #}
                # Always print this which is all the qc_metrics
                print "$decoded->{'qc_metrics'}[$l]->{'read_group_id'},";
                foreach my $order ("#_total_reads_r2","read_length_r1","#_gc_bases_r1","platform_unit","#_duplicate_reads","#_mapped_bases","mean_insert_size","library","#_mapped_reads_r1","#_divergent_bases","#_mapped_reads_properly_paired","#_divergent_bases_r2","read_length_r2","#_mapped_bases_r1","sample","platform","readgroup","#_divergent_bases_r1","#_mapped_bases_r2","#_total_reads","#_gc_bases_r2","median_insert_size","insert_size_sd","bam_filename","#_total_reads_r1","#_mapped_reads_r2","#_mapped_reads"){
                        for my $key (keys $decoded->{'qc_metrics'}[$l]->{'metrics'}){
                                if ($key eq $order && $key ne "#_mapped_reads"){
                                        print "$decoded->{'qc_metrics'}[$l]->{'metrics'}->{$key},";
                                }
                                elsif ($key eq $order && $key eq "#_mapped_reads"){
                                        print "$decoded->{'qc_metrics'}[$l]->{'metrics'}->{$key}\n";
                                }
                        }
                }
        }}
        else{$check=$check;}
        $check++;
        $countme++;}
# If $thing is not found then put comma for empty field
elsif ($thing ne 'qc_metrics' && $check != 1 && $i == scalar @attr - 1){
        print ",";}
#       push(@str,",")}
elsif ($thing eq 'qc_metrics' && $check != 1 && $i == scalar @attr - 1){
        print ",,,,,,,,,,,,,,,,,,,,,,,,,,,\n";}
}
}
