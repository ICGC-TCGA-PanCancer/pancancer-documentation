#!/usr/bin/perl 

use strict;
#use warnings;

use CGI;
use JSON 2;
use IO::Handle;
my $count = 0;

my @lines;
my @total_bases;
my $total;
my $ave;
my @average;
my @projects;
my %spec;
my $map_base;
my $map_reads;
my $diver_bases;
my $proper;
my $dup;
my @mapb;
my @mapr;
my @diver;
my @prop;
my @dupli;

#opens the file containing upload info 
open(FH,"/home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/all.csv") or die("Can't open all.csv: $!");
while (my $line = <FH>) {
  chomp $line;
  my @fields = split "," , $line;
  # Making sure that the line has all the necessary fields
  # LIHC-US does not parse properly so we must take it out for now
  if ($fields[13] ne "" && $fields[4] ne "" && $fields[4] ne "Primary tumour - solid tissue" && $fields[4] ne "Normal - other" && $fields[0] ne "date"){
    	# Calculating the total bases per readgroup
    	$total = ($fields[10] * $fields[22]) + ($fields[11]*$fields[34]);
    	# Calculating the average coverage per readgroup
    	$ave = $total/3000000000;
        $map_base = ($fields[15]/$total)*100;
        $diver_bases = ($fields[19]/$total)*100;
        $map_reads = ($fields[36]/$fields[29])*100;
        $proper = ($fields[20]/$fields[29])*100;
        $dup = ($fields[14]/$fields[29])*100;
    	push(@mapb,$map_base);
	push(@mapr,$map_reads);
    	push(@diver,$diver_bases);
    	push(@prop,$proper);
    	push(@dupli,$dup);
   	push(@average,$ave);
    	push(@total_bases,$total);
    	push (@lines,$line);
  }
}
close(FH);

open(my $file, '>',"/home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/all_qc1.csv") or die ("Can't open all_qc1.csv: $!");
for (my $i = 0; $i < scalar @lines;$i++){
        if ($i == 0){print $file "$lines[0]\n";}
        else{print $file "$lines[$i],$total_bases[$i],$average[$i],$mapb[$i],$mapr[$i],$diver[$i],$prop[$i],$dupli[$i]\n";}
};
close $file;

# Getting rid of all the duplicates
open(FH,"/home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/all_qc1.csv") or die("Can't open all_qc1.csv: $!");
while (my $line = <FH>) {
  chomp $line;
  my @fields = split "," , $line;
  # Using specimen_id and ____ as UUID 
  $spec{$fields[6]}{$fields[10]}{"value"} = $line;
  push(@projects,$line);
}
close(FH);

# Printing all the values in the hash to get file with no duplicates
for my $key ( keys %spec ) {
  for my $item ( keys $spec{$key}){
    print qq($spec{$key}{$item}{"value"}\n);
  }
}
