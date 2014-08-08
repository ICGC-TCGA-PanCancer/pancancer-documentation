#!/usr/bin/perl 

use strict;
use warnings;
use CGI;
use JSON 2;
use IO::Handle;
use Data::Dumper;
use String::Util 'trim';
my %id;

#my $str = "  df ";
#$str = trim($str);
#print "string '$str'\n";

my @spec_marc;

# train_1.csv is the data freeze 1.0 spresheet found here:
# https://docs.google.com/spreadsheets/d/14NItsHKJUevHZIuFkFTwNF-C12WbXTrFe0oM0Xq6b4M/edit#gid=111470950
open(FH,"train_1.csv") or die("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
  chomp $line;
  my @cols = split "," , $line;
  #print "$cols[4],";
  push (@spec_marc,$cols[4]);
}
close(FH);

#print "[\n";

#check if specimen id has changed or not
#only count when it has changed

#opens the file containing upload info 
for my $elem ("gtrepo-bsc","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-osdc-icgc","gtrepo-riken","gtrepo-cghub"){
my $data2 = 0;
my $data1 = 0;
my $unaligned_total = 0;
my $check = 0;
my $check2 = 0;
my $line_num = 0;
my $spec;
open(FH,"$elem.log") or die("Can't open $elem.log: $!");
while (my $line = <FH>) {
        $line_num += 1;
# reset the check
if (index($line,"SPECIMEN/SAMPLE:") != -1){
        $spec = trim(substr($line,index($line,"SPECIMEN/SAMPLE:")+17));
        $id{$spec} += 1;
        $check = 0;
        $check2 = 0;
}
# does line contain alignment? and is the specimen_id nonempty?
if (index($line,"ALIGNMENT:") != -1 && $spec ne ""){
# is it unaligned?
if (index($line,"unaligned") != -1) {
        if ($spec ~~ @spec_marc){
        #print "$line_num $line\n";
        $unaligned_total += 1;
        }
}
# does it NOT have "workflow" in it?
elsif (index($line,"Workflow") == -1){
        if ($spec ~~ @spec_marc){
        $check += 1;
        # only count the first occurence 
        if ($check == 1){
        #       print "$spec,";
                #print "$line_num $line\n";
                $data1 += 1;}
        }
        else {print "$spec\n";};
}
# does it have "workflow" in it?
elsif (index($line,"Workflow") != -1){
        $check2 += 1;
        #print "$line\n";
        if ($check2 == 1){
        $data2+=1;};
        }
}
}
close(FH);

my $unaligned_remain = $unaligned_total - ($data1+$data2);
if ($unaligned_remain < 0) {$unaligned_remain = 0;}

if ($elem ne "gtrepo-cghub"){
print qq({"repo": $elem, "train_1_align": $data1, "train_2_align": $data2, "total_unalign": $unaligned_total, "remaining": $unaligned_remain},\n);}
else{
print qq({"repo": $elem, "train_1_align": $data1, "train_2_align": $data2, "total_unalign": $unaligned_total, "remaining": $unaligned_remain}\n);};

print "$elem\n";
print "data train 1 ALIGNED: $data1\n";
print "data train 2 ALIGNED: $data2\n";
print "unaligned total: $unaligned_total\n";
print "unaligned remaining: $unaligned_remain\n";
}
