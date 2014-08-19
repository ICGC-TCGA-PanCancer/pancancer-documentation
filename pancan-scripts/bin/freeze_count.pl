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
my %spec;
my @spec_marc2;
my $output = "json";

if (scalar(@ARGV) != 2) { die "USAGE: perl freeze_count.pl --output <OUTPUT TYPE>"; }
GetOptions ("output=s" => \$output);

open(FH,"train_2.tsv") or die("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
  chomp $line;
  my @cols = split "\t" , $line;  #print "$cols[4],";
if($cols[0] ne "Study" && $cols[0] ne ""){
        push (@{$id{$cols[1]}{$cols[2]}},$cols[7]);
        push (@spec_marc2,$cols[1]);
        $spec{$cols[1]} += 1;
}
}
close(FH);

my $total_count = scalar @spec_marc2;
my $total_pair=0;
my $icgc_count=0;
my $icgc_pair=0;
my $tcga_count=0;
my $tcga_pair=0;

my $i;
for ($i = 0;$i < scalar @spec_marc2;$i++){
        if (index($spec_marc2[$i],"US") != -1){$tcga_count += 1;}
        else {$icgc_count++;};
}

for my $key (keys %id){
        for my $elem (keys $id{$key}){
                if ("Normal" ~~ $id{$key}{$elem} and "Tumour" ~~ $id{$key}{$elem}){
                $total_pair += 1;
                if (index($key,"US") != -1){$tcga_pair += 1;}
                else {$icgc_pair += 1;}
                }
        }
}

#print Dumper(\%id);

if ($output eq "json"){
print qq(
[
        {"name": "ICGC Total", "total": "NA", "uploaded": $icgc_count, "left": "NA", "matched": $icgc_pair},

        {"name": "TCGA Total", "total": "NA", "uploaded": $tcga_count, "left": "NA", "matched": $tcga_pair},

        {"name": "Cumulative Total", "total": "NA", "uploaded": $total_count, "left": "NA", "matched": $tcga_pair}

]);}

elsif($output eq "csv"){
print "project,total\n";
for my $thing (keys %spec){
        print "$thing,$spec{$thing}\n"
}}
