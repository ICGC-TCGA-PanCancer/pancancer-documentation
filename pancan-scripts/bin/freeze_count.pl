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
my $file = "train_2.tsv";

if (scalar(@ARGV) != 4) { die "USAGE: perl freeze_count.pl --file <INPUT FILE> --output <OUTPUT TYPE> tsv or json"; }
GetOptions ("output=s" => \$output, "file=s" => \$file);

open(FH,$file) or die("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
        chomp $line;
        my @cols = split "\t" , $line; 

        if($cols[0] ne "Study" && $cols[0] ne ""){
                my $index;
                for (my $i=0;$i < scalar @cols;$i++){
                        if ($cols[$i] eq "Tumour" or $cols[$i] eq "Normal"){
                                $index = $i;
                        }}
                push (@{$id{$cols[1]}{$cols[2]}},$cols[$index]);
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
        {"name": "ICGC Total", "uploaded": $icgc_count, "matched": $icgc_pair},

        {"name": "TCGA Total",  "uploaded": $tcga_count, "matched": $tcga_pair},

        {"name": "Cumulative Total", "uploaded": $total_count, "matched": $tcga_pair}

]);}

elsif($output eq "tsv"){
print "project\ttotal\n";
for my $thing (keys %spec){
        print "$thing\t$spec{$thing}\n"
}}
