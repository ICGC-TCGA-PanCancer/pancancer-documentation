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
my @projects;
my %spec;
my $str;

#opens the file containing upload info 
open(FH,"all_qc.csv") or die("Can't open all_qc.csv: $!");
while (my $line = <FH>) {
  chomp $line;
  my @fields = split "," , $line;
if ($fields[0] ne "date"){
  $spec{$fields[6]}{"value"} += $fields[37];
  $spec{$fields[6]}{"project"} = $fields[2];
  $spec{$fields[6]}{"type"} = $fields[3];
  $spec{$fields[6]}{"date"} = $fields[0];
  $spec{$fields[6]}{"aliquot_id"} = $fields[1];
  $spec{$fields[6]}{"donor_id"} = $fields[4];
  $spec{$fields[6]}{"sample_id"} = $fields[5];
  $spec{$fields[6]}{"total_lanes"} = $fields[7];
  $spec{$fields[6]}{"use_cntl"} = $fields[8];
  $spec{$fields[6]}{"readgroup_id"} = $fields[9];
  $spec{$fields[6]}{"total_reads_r2"} += $fields[10];
  $spec{$fields[6]}{"read_length_r1"} += $fields[11];
  $spec{$fields[6]}{"gc_bases_r1"} += $fields[12];
  $spec{$fields[6]}{"platform_unit"} = $fields[13];
  $spec{$fields[6]}{"duplicate_reads"} += $fields[14];
  $spec{$fields[6]}{"mapped_bases"} += $fields[15];
  $spec{$fields[6]}{"mean_insert_size"} += $fields[16];
  $spec{$fields[6]}{"library"} = $fields[17];
  $spec{$fields[6]}{"mapped_reads_r1"} += $fields[18];
  $spec{$fields[6]}{"divergent_bases"} += $fields[19];
  $spec{$fields[6]}{"properly_paired"} += $fields[20];
  $spec{$fields[6]}{"divergent_bases_r2"} += $fields[21];
  $spec{$fields[6]}{"read_length_r2"} += $fields[22];
  $spec{$fields[6]}{"mapped_bases_r1"} += $fields[23];
  $spec{$fields[6]}{"sample"} = $fields[24];
  $spec{$fields[6]}{"platform"} = $fields[25];
  $spec{$fields[6]}{"readgroup"} = $fields[26];
  $spec{$fields[6]}{"divergent_bases_r1"} += $fields[27];
  $spec{$fields[6]}{"mapped_bases_r2"} += $fields[28];
  $spec{$fields[6]}{"total_reads"} += $fields[29];
  $spec{$fields[6]}{"gc_bases_r2"} += $fields[30];
  $spec{$fields[6]}{"median_insert_size"} += $fields[31];
  $spec{$fields[6]}{"insert_size_sd"} += $fields[32];
  $spec{$fields[6]}{"bam"} = $fields[33];
  $spec{$fields[6]}{"total_reads_r1"} += $fields[34];
  $spec{$fields[6]}{"mapped_reads_r2"} += $fields[35];
  $spec{$fields[6]}{"mapped_reads"} += $fields[36];
  $spec{$fields[6]}{"total_bases"} += $fields[37];
  $spec{$fields[6]}{"average_coverage"} += $fields[38];
}
else{$str = $line};
}
close(FH);

print "$str\n";
#print "date,aliquot_id,dcc_project_code,dcc_specimen_type,submitter_donor_id,submitter_sample_id,submitter_specimen_id,total_lanes,use_cntl,#_total_bases_spec,average_coverage_spec\n";
for my $key ( keys %spec ) {
        my $total = $spec{$key}{"value"};
        my $ave = $spec{$key}{"value"}/3000000000;
        my $proj = $spec{$key}{"project"};
        my $type = $spec{$key}{"type"};
        my $date = $spec{$key}{"date"};
        my $ali = $spec{$key}{"aliquot_id"};
        my $donor = $spec{$key}{"donor_id"};
        my $sample_id = $spec{$key}{"sample_id"};
        my $lanes = $spec{$key}{"total_lanes"};
        my $cntl = $spec{$key}{"use_cntl"};
        my $read_id = $spec{$key}{"readgroup_id"};
        my $total_reads_r2 = $spec{$key}{"total_reads_r2"};
        my $read_length_r1 = $spec{$key}{"read_length_r1"};
        my $gc_bases_r1 = $spec{$key}{"gc_bases_r1"};
        my $platform_unit = $spec{$key}{"platform_unit"};
        my $duplicate_reads = $spec{$key}{"duplicate_reads"};
        my $mapped_bases = $spec{$key}{"mapped_bases"};
        my $mean_insert_size = $spec{$key}{"mean_insert_size"};
        my $library = $spec{$key}{"library"};
        my $mapped_reads_r1 = $spec{$key}{"mapped_reads_r1"};
        my $divergent_bases = $spec{$key}{"divergent_bases"};
        my $properly_paired = $spec{$key}{"properly_paired"};
        my $divergent_bases_r2 = $spec{$key}{"divergent_bases_r2"};
        my $read_length_r2 = $spec{$key}{"read_length_r2"};
        my $mapped_bases_r1 = $spec{$key}{"mapped_bases_r1"};
        my $sample = $spec{$key}{"sample"};
        my $platform = $spec{$key}{"platform"};
        my $readgroup = $spec{$key}{"readgroup"};
        my $divergent_bases_r1 = $spec{$key}{"divergent_bases_r1"};
        my $mapped_bases_r2 = $spec{$key}{"mapped_bases_r2"};
        my $total_reads = $spec{$key}{"total_reads"};
        my $gc_bases_r2 = $spec{$key}{"gc_bases_r2"};
        my $median_insert_size = $spec{$key}{"median_insert_size"};
        my $insert_size_sd = $spec{$key}{"insert_size_sd"};
        my $bam = $spec{$key}{"bam"};
        my $total_reads_r1 = $spec{$key}{"total_reads_r1"};
        my $mapped_reads_r2 = $spec{$key}{"mapped_reads_r2"};
        my $mapped_reads = $spec{$key}{"mapped_reads"};
        my $total_bases = $spec{$key}{"total_bases"};
        my $average_coverage = $spec{$key}{"average_coverage"};
        my $per_mapped_bases = ($spec{$key}{"mapped_bases"}/$spec{$key}{"total_bases"})*100;
        my $per_mapped_reads = ($spec{$key}{"mapped_reads"}/$spec{$key}{"total_reads"})*100;
        my $per_diver_bases = ($spec{$key}{"divergent_bases"}/$spec{$key}{"total_bases"})*100;
        my $per_proper = ($spec{$key}{"properly_paired"}/$spec{$key}{"total_reads"})*100;
        my $per_dup = ($spec{$key}{"duplicate_reads"}/$spec{$key}{"total_reads"})*100;
        print "$date,$ali,$proj,$type,$donor,$sample_id,$key,$lanes,$cntl,$read_id,$total_reads_r2,$read_length_r1,$gc_bases_r1,$platform_unit,$duplicate_reads,$mapped_bases,$mean_insert_size,$library,$mapped_reads_r1,$divergent_bases,$properly_paired,$divergent_bases_r2,$read_length_r2,$mapped_bases_r1,$sample,$platform,$readgroup,$divergent_bases_r1,$mapped_bases_r2,$total_reads,$gc_bases_r2,$median_insert_size,$insert_size_sd,$bam,$total_reads_r1,$mapped_reads_r2,$mapped_reads,$total,$ave,$per_mapped_bases,$per_mapped_reads,$per_diver_bases,$per_proper,$per_dup\n";
    }
