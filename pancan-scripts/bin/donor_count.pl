use strict;
use warnings;
use Data::Dumper;
use Dumpvalue;
 
binmode STDOUT, ":utf8";
use utf8;
 
use JSON;
 
my $json;
{
  local $/; #Enable 'slurp' mode
  open my $fh, "<", "donor_p_20141117035310.jsonl";
  $json = <$fh>;
  close $fh;
}

my $total;
my $total_align;
my $total_donor;
my $total_donor_align;
my %chekck;
my @blacklist = ("LAML-US::9c022254-f9f7-4c61-be48-48c60a92448e","BRCA-US::01eef340-598c-4205-a990-cec190ac2ca5","BRCA-US::5a57dc25-d252-4b22-b192-4de630d7002f","LAML-US::ff7839bb-176e-4483-ac6e-7fae9f6e2e54","HNSC-US::6909302d-358a-46cd-8052-eedb09c83c83","LIHC-US::2854ffe8-1f77-497a-bf49-11e0189fee35","SKCM-US::238111f9-a08b-49b4-9035-cc43026330e7","GBM-US::6176621d-8534-4fba-a0e7-74a5a78245a9","BRCA-US::eb2dbb4f-66b6-4525-8323-431970f7a64e","LUAD-US::e737f650-b72d-44e7-b750-558a56716803");
my @repos = ("EBI","ETRI","OSDC-ICGC","RIKEN","DKFZ","BSC","CGHUB");
my @repo_align;
my @repo_total;
my @repo_donor_align;
my @repo_donor_total;
my @lines = split /\n/, $json;
#my $data = from_json($lines[15]);
#print "$data->{'normal_specimen'}->{'is_aligned'}\n";
my $i=0;
for ($i=0;$i < scalar(@lines);$i++){
my $data = from_json($lines[$i]);
#print Dumper $data;
#print "Dumpvalue:\n";
#Dumpvalue->new->dumpValue($data->{'aligned_tumor_specimens'}[0]->{'submitter_specimen_id'});
if ($data->{'gnos_repo'} eq "https://gtrepo-osdc-icgc.annailabs.com/"){
#print "$data->{'aligned_tumor_specimens'}[0]->{'submitter_specimen_id'}\n";
}
#print "repo: $data->{'gnos_repo'} | ";
#print "$data->{'donor_unique_id'},";
my $val = $data->{'all_tumor_specimen_aliquot_counts'}+1;
my $align = $data->{'aligned_tumor_specimen_aliquot_counts'};
if ($data->{'normal_specimen'}->{'is_aligned'} == 1){
$align++;
if ($data->{'gnos_repo'} eq "https://gtrepo-osdc-icgc.annailabs.com/"){
#print "$data->{'normal_specimen'}->{'submitter_specimen_id'}\n";
}
}
#print "aligned_tumor_specimen_aliquot_counts: $align | ";
#print "all_tumor_specimen_aliquot_counts: $val\n";
$total += $val;
$total_align += $align;
if ($val == $align){
$total_donor_align++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
#EBI = 0 
if ($data->{'gnos_repo'} eq "https://gtrepo-ebi.annailabs.com/"){
$repo_donor_total[0]++;
$repo_total[0] += $val;
$repo_align[0] += $align;
if ($val == $align){
$repo_donor_align[0]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#ETRI = 1
elsif($data->{'gnos_repo'} eq "https://gtrepo-etri.annailabs.com/"){
$repo_donor_total[1]++;
$repo_total[1] += $val;
$repo_align[1] += $align;
if ($val == $align){
$repo_donor_align[1]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#OSDC-ICGC = 2
elsif($data->{'gnos_repo'} eq "https://gtrepo-osdc-icgc.annailabs.com/"){
$repo_donor_total[2]++;
$repo_total[2] += $val;
$repo_align[2] += $align;
if ($val == $align){
$repo_donor_align[2]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#RIKEN = 3
elsif($data->{'gnos_repo'} eq "https://gtrepo-riken.annailabs.com/"){
$repo_donor_total[3]++;
$repo_total[3] += $val;
$repo_align[3] += $align;
if ($val == $align){
$repo_donor_align[3]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#DKFZ = 4
elsif($data->{'gnos_repo'} eq "https://gtrepo-dkfz.annailabs.com/"){
$repo_donor_total[4]++;
$repo_total[4] += $val;
$repo_align[4] += $align;
if ($val == $align){
$repo_donor_align[4]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#BSC = 5
elsif($data->{'gnos_repo'} eq "https://gtrepo-bsc.annailabs.com/"){
$repo_donor_total[5]++;
$repo_total[5] += $val;
$repo_align[5] += $align;
if ($val == $align){
$repo_donor_align[5]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}
#CGHUB = 6
elsif($data->{'gnos_repo'} eq "https://cghub.ucsc.edu/"){
$repo_donor_total[6]++;
$repo_total[6] += $val;
$repo_align[6] += $align;
if ($val == $align){
$repo_donor_align[6]++ unless ($data->{'donor_unique_id'} ~~ @blacklist);
}
}

}
#foreach my $key (keys %repos){
#print "$key\n";
#}
$total_donor=scalar(@lines);
#$total_donor_align = $total_donor_align - 10;
my @spec_perc;
my @donor_perc;
my $spec_ave=0;
my $donor_ave=0;
print "TOATAL SPEC: $total\n";
print "TOTAL ALIGN: $total_align\n";
my $percent = sprintf "%.2f",100*($total_align/$total);
print "% ALIGNED : $percent\n";
print "TOTAL DONORS: $total_donor\n";
print "TOTAL DONORS FULLY ALIGNED: $total_donor_align\n";
my $donor_percent = sprintf "%.2f",100*($total_donor_align/$total_donor);
print "% DONORS FULLY ALIGNED: $donor_percent\n";
my $t=0;
for ($t=0;$t < scalar(@repos);$t++){
print "$repos[$t]\nTOTAL SPEC: $repo_total[$t]\nTOTAL ALIGN: $repo_align[$t]\n";
$spec_ave = 100*($repo_align[$t]/$repo_total[$t]);
$spec_perc[$t]=sprintf "%.2f",$spec_ave;
print "TOTAL DONORS: $repo_donor_total[$t]\nTOTAL DONORS FULLLY ALIGNED: $repo_donor_align[$t]\n";
$donor_ave = 100*($repo_donor_align[$t]/$repo_donor_total[$t]);
$donor_perc[$t]=sprintf"%.2f",$donor_ave;
}

#print qq(
#<tbody>
#<tr><td><b>Aligned Specimens</b></td>
#<td>$repo_align[5]</td><td>$repo_align[2]</td><td>Offline</td><td>$repo_align[4]</td><td>$repo_align[0]</td><td>$repo_align[1]</td><td>$repo_align[3]</td><td>$repo_align[6]</td><td>$total_align</td></tr>

#<tr><td><b>Total Specimens</b></td>
#<td>$repo_total[5]</td><td>$repo_total[2]</td><td>Offline</td><td>$repo_total[4]</td><td>$repo_total[0]</td><td>$repo_total[1]</td><td>$repo_total[3]</td><td>$repo_total[6]</td><td>$total</td></tr>

#<tr><td><b>% Specimens Aligned</b></td>
#<td>$spec_perc[5]</td><td>$spec_perc[2]</td><td>Offline</td><td>$spec_perc[4]</td><td>$spec_perc[0]</td><td>$spec_perc[1]</td><td>$spec_perc[3]</td><td>$spec_perc[6]</td><td>$percent</td></tr>

#<tr><td><b>Fully Aligned Donors</b></td>
#<td>$repo_donor_align[5]</td><td>$repo_donor_align[2]</td><td>Offline</td><td>$repo_donor_align[4]</td><td>$repo_donor_align[0]</td><td>$repo_donor_align[1]</td><td>$repo_donor_align[3]</td><td>$repo_donor_align[6]</td><td>$total_donor_align</td></tr>

#<tr><td><b>Total Donors</b></td>
#<td>$repo_donor_total[5]</td><td>$repo_donor_total[2]</td><td>Offline</td><td>$repo_donor_total[4]</td><td>$repo_donor_total[0]</td><td>$repo_donor_total[1]</td><td>$repo_donor_total[3]</td><td>$repo_donor_total[6]</td><td>$total_donor</td></tr>

#<tr><td><b>% Donors Fully Aligned</b></td>
#<td>$donor_perc[5]</td><td>$donor_perc[2]</td><td>Offline</td><td>$donor_perc[4]</td><td>$donor_perc[0]</td><td>$donor_perc[1]</td><td>$donor_perc[3]</td><td>$donor_perc[6]</td><td>$donor_percent</td></tr>
#</tbody>);
#foreach my $line (@lines){
#my $data = from_json($line);
#print Dumper $data;
#my $to = to_json($data);
#my $thing = decode_json($to);
#print $data->{'all_tumor_specimen_aliquot_counts'};
#}
