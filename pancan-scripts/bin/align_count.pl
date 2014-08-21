#!/usr/bin/perl 

use strict;
#use warnings;
use CGI;
use JSON 2;
use IO::Handle;
use Data::Dumper;
use String::Util 'trim';
use Getopt::Long;
use POSIX qw(strftime);
my %id;

my $train;
my $last = 0;
my $last1;
my $last2;
my $change;
my @train1_align;
my @train2_align;
my @train1_unalign;
my @train2_unalign;
my $align_total_archive = 0;

if (scalar(@ARGV) != 2) { die "USAGE: perl align_count.pl --train <TRAIN NUMBER>i"; }
GetOptions ("train=s" => \$train);

my @spec_marc1;
my @spec_marc2;

# train_1.csv is the data freeze 1.0 spresheet found here:
# https://docs.google.com/spreadsheets/d/14NItsHKJUevHZIuFkFTwNF-C12WbXTrFe0oM0Xq6b4M/edit#gid=111470950
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/train_1.tsv") or die("Can't open train_1.tsv $!");
while (my $line = <FH>) {
  chomp $line;
  my @cols = split "\t" , $line;
  #print "$cols[4],";
  push (@spec_marc1,$cols[3]);
}
close(FH);

open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/train_2.tsv") or die("Can't open train_2.tsv $!");
while (my $line = <FH>) {
  chomp $line;
  my @cols = split "\t" , $line;  #print "$cols[4],";
  push (@spec_marc2,$cols[3]);
}
close(FH);

my @ary;
if ($train eq "1"){
@ary = ("gtrepo-bsc","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-osdc-icgc","gtrepo-riken","gtrepo-cghub_data1");}
elsif($train eq "2"){
@ary = ("gtrepo-bsc","gtrepo-osdc-icgc","gtrepo-osdc-tcga","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-riken","gtrepo-cghub");}
elsif ($train eq "all"){
@ary = ("gtrepo-bsc","gtrepo-osdc-icgc","gtrepo-osdc-tcga","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-riken","gtrepo-cghub_data1","gtrepo-cghub");}
elsif ($train eq "bubbles"){
@ary = ("gtrepo-bsc","gtrepo-osdc-icgc","gtrepo-osdc-tcga","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-riken","gtrepo-cghub");}

if ($train ne "bubbles"){
print "[\n";}

#check if specimen id has changed or not
#only count when it has changed

#opens the file containing upload info 
for my $elem (@ary){
my $data2 = 0;
my $data1 = 0;
my $data_all = 0;
my $unaligned_total1 = 0;
my $unaligned_total2 = 0;
my $all_unalign = 0;
my $check = 0;
my $check2 = 0;
my $check_all = 0;
my $line_num = 0;
my $spec;
my $bool;
open(FH,"$elem.log") or die("Can't open ../$elem.log: $!");
while (my $line = <FH>) {
        $line_num += 1;
# reset the check
if (index($line,"SPECIMEN/SAMPLE:") != -1){
        $all_unalign += 1;
        $spec = trim(substr($line,index($line,"SPECIMEN/SAMPLE:")+17));
        $id{$spec} += 1;
        $check = 0;
        $check2 = 0;
        $check_all = 0;
}
# does line contain alignment? and is the specimen_id nonempty?
if (index($line,"ALIGNMENT:") != -1 && $spec ne ""){
# is it unaligned?
if (index($line,"unaligned") != -1) {
        if ($spec ~~ @spec_marc1){
        #print "$line_num $line\n";
        $unaligned_total1 += 1;
        }
        elsif ($spec ~~ @spec_marc2){
        $unaligned_total2 += 1;
        }
}
# does it NOT have "workflow" in it?
elsif (index($line,"Workflow") == -1){
#        $check_all += 1;
        if($train eq "1" or $train eq "2"){
        if ($spec ~~ @spec_marc1){
        $check += 1;
        # only count the first occurence 
        if ($check == 1){
        #       print "$spec,";
                #print "$line_num $line\n";
                $data1 += 1;}
        }}
   #     else{
 #       if($check_all == 1){
  #              $data_all += 1;
#       print "line $line_num\n";
    #    }}
}
# does it have "workflow" in it?
elsif (index($line,"Workflow") != -1){
        $check_all += 1;
        if ($train eq "1" or $train eq "2"){
        if($spec ~~ @spec_marc2){
        $check2 += 1;
        #print "$line\n";
        if ($check2 == 1){
        $data2+=1;};
        }}
        else{
        if($check_all == 1){
#               print "line $line_num\n";
                $data_all += 1;
        }}
}
elsif($check_all == 1){
$data_all += 1;
}

}
}
close(FH);

my $unaligned_remain1 = $unaligned_total1 - $data1;
my $unaligned_remain2 = $unaligned_total2 - $data2;
my $all_remain = $all_unalign - $data_all;
if ($unaligned_remain1 < 0) {$unaligned_remain1 = 0;}
elsif ($unaligned_remain2 < 0) {$unaligned_remain2 = 0;}
elsif ($all_remain < 0) {$all_remain = 0;}
if ($unaligned_total2 < $data2){$unaligned_total2 = $data2;}
elsif($unaligned_total1 < $data1){$unaligned_total1 = $data1;}
elsif($all_unalign < $data_all){$all_unalign = $data_all;}

if ($train eq "1"){
if ($elem ne "gtrepo-cghub_data1"){
print qq({"repo": "$elem", "align": $data1, "total_unalign": $unaligned_total1, "remaining": $unaligned_remain1},\n);}
else{
print qq({"repo": "$elem", "align": $data1, "total_unalign": $unaligned_total1, "remaining": $unaligned_remain1}\n);}
}

elsif($train eq "2"){
if ($elem ne "gtrepo-cghub"){
print qq({"repo": "$elem", "align": $data2, "total_unalign": $unaligned_total2, "remaining": $unaligned_remain2},\n);}
else{
print qq({"repo": "$elem", "align": $data2, "total_unalign": $unaligned_total2, "remaining": $unaligned_remain2}\n);}
}

elsif($train eq "all"){
if ($elem ne "gtrepo-cghub" && $elem ne "gtrepo-cghub_data1"){
print qq({"repo": "$elem", "align": $data_all, "total_unalign": $all_unalign, "remaining": $all_remain},\n);}
elsif($elem eq "gtrepo-cghub"){
$data_all = $data_all + $last;
$all_unalign = $all_unalign + $last1;
$all_remain = $all_remain + $last2;
print qq({"repo": "$elem", "align": $data_all, "total_unalign": $all_unalign, "remaining": $all_remain}\n);}
}

$align_total_archive += $data2;
$last = $data_all;
$last1 = $all_unalign;
$last2 = $all_remain;
push (@train1_align,$data1);
push (@train2_align,$data2);
push (@train1_unalign,$unaligned_total1);
push (@train2_unalign,$unaligned_total2);
}

if ($train ne "bubbles"){
print "]";}

my $date = strftime "%B %d %Y %R", localtime;

open(my $file1,'>>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/align_archive.csv");
if($train eq "2"){
print $file1 "$date,$align_total_archive\n";}
close $file1;


my @rad;
my @size;
my @ave;

my $h = 0;
for ($h = 0; $h < scalar @train2_unalign; $h++){
#       print "$h $train2_unalign[$h]\n";
        if ($train2_unalign[$h] == 0){$ave[$h]=0}
        else{
        $ave[$h] = ($train2_align[$h]/$train2_unalign[$h])*100;}

        if($train2_unalign[$h] <= 120 && $train2_unalign[$h] >=0){$rad[$h] = 15;}
                elsif($train2_unalign[$h] <= 500 && $train2_unalign[$h] >=120){$rad[$h] = 20;}
                elsif($train2_unalign[$h] <= 500 && $train2_unalign[$h] >=800){$rad[$h] = 25;}
                else{$rad[$h] = 30;};

        $size[$h] = $rad[$h]*$ave[$h]/100;
        if ($size[$h] >= 0.0 && $size[$h] < 3){$size[$h] = 3;};

}

if ($train eq "bubbles"){
print qq([
       {"name": "Chicago(ICGC)", "total": $train2_unalign[1], "aligned": $train2_align[1], "latitude": 41.891519, "longitude": -87.629159, "radius": $rad[1], "fillKey": "gt60"},
       {"name": "Chicago(ICGC)", "total": $train2_unalign[1], "aligned": $train2_align[1], "latitude": 41.891519, "longitude": -87.629159, "radius": $size[1], "fillKey": "gt70"},

       {"name": "Chicago(TCGA)", "total": $train2_unalign[2], "aligned": $train2_align[2], "latitude": 41.891519, "longitude": -87.629159, "radius": $rad[2], "fillKey": "gt60"},
       {"name": "Chicago(TCGA)", "total": $train2_unalign[2], "aligned": $train2_align[2], "latitude": 41.891519, "longitude": -87.629159, "radius": $size[2], "fillKey": "gt70"},

       {"name": "Barcelona", "total": $train2_unalign[0], "aligned": $train2_align[0], "latitude": 41.378691, "longitude": 2.175547, "radius": $rad[0], "fillKey": "gt60"},
       {"name": "Barcelona", "total": $train2_unalign[0], "aligned": $train2_align[0], "latitude": 41.378691, "longitude": 2.175547, "radius": $size[0], "fillKey": "gt70"},
 
       {"name": "Tokyo", "total": $train2_unalign[6], "aligned": $train2_align[6], "latitude": 35.684219, "longitude": 139.755020, "radius": $rad[6], "fillKey": "gt60"},
       {"name": "Tokyo", "total": $train2_unalign[6], "aligned": $train2_align[6], "latitude": 35.684219, "longitude": 139.755020, "radius": $size[6], "fillKey": "gt70"},

       {"name": "Seoul", "total": $train2_unalign[5], "aligned": $train2_align[5], "latitude": 37.553397, "longitude": 126.980624, "radius": $rad[5], "fillKey": "gt60"},
       {"name": "Seoul", "total": $train2_unalign[5], "aligned": $train2_align[5], "latitude": 37.553397, "longitude": 126.980624, "radius": $size[5], "fillKey": "gt70"},

       {"name": "Heidelberg", "total": $train2_unalign[3], "aligned": $train2_align[3], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[3], "fillKey": "gt60"},
       {"name": "Heidelberg", "total": $train2_unalign[3], "aligned": $train2_align[3], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[3], "fillKey": "gt70"},

       {"name": "London", "total": $train2_unalign[4], "aligned": $train2_align[4], "latitude": 51.507919, "longitude": -0.123571, "radius": $rad[4], "fillKey": "gt60"},
       {"name": "London", "total": $train2_unalign[4], "aligned": $train2_align[4], "latitude": 51.507919, "longitude": -0.123571, "radius": $size[4], "fillKey": "gt70"},

       {"name": "Santa Cruz", "total": $train2_unalign[7], "aligned": $train2_align[7], "latitude": 36.971944, "longitude": -122.026389, "radius": $size[7], "fillKey": "gt70"}
]);}
