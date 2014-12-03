#!/usr/bin/perl 

use strict;
use warnings;

use JSON 2;
use IO::Handle;
use JSON qw( decode_json );

my $filename = 'config.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);
my $path = $data->{"main_path"};

my ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual);

my ($all_emp_count, $all_fill_count) = (0)x2;

# For all the arrays 
# [0]=Heidelberg,[1]=Cambridge,[2]=Toronto,[3]=Barcelona,[4]=Singapore,[5]=Tokyo,[6]=Hinxton,[7]=Seoul
my @fill_counts;
my @emp_counts;
my @col;
my @rad;
my @size;
my @ave;
my @uploads;
my @tumour;
my @normal;
my @totals2;

my ($projectcode,$leadjurisdiction,$tumourtype,$gnos,$pledgednumberofwgstnpairs,$numberofwgstnpairstheyaretracking,$numberofspecimens,$numberofspecimensuploaded,$percentuploaded,$pairuploaded,$alignedspecimens,$alignedpair);
my @totals;
my $totals_match;
my $total_icgc;
my @up;
my @uplo;
my @matches_up;
my $missing;
my $bar_count;
my $boca_count;
my $cmdi_count;
my $brcaeu_count;
my $marc_count;
my $prad_count;
my $esad_count;
my $brca_count;

# reading from text file containing summary of all the projects
# individual project text files created from get_uplaods.pl
open (FILE, "$path/results/summary.txt") or die ("Could not open summary.txt");
while (<FILE>) {
chomp;
($projectcode,$leadjurisdiction,$tumourtype,$gnos,$pledgednumberofwgstnpairs,$numberofwgstnpairstheyaretracking,$numberofspecimens,$numberofspecimensuploaded,$percentuploaded,$pairuploaded,$alignedspecimens,$alignedpair) = split("\t");

if ($projectcode ne 'Project Code' && $projectcode ne ''){
		if (substr($projectcode,5,6) eq 'SG'){
		        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[4] = $numberofspecimensuploaded;
                        $matches_up[4] = $pairuploaded;
                        $totals[4] += $numberofspecimens;}
                elsif (substr($projectcode,5,6) eq 'ES'){
                        $bar_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[3] = $numberofspecimensuploaded;
                        $matches_up[3] = $pairuploaded;
                        $totals[3] += $numberofspecimens;}
                elsif ($projectcode eq 'LIRI-JP'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[17] = $numberofspecimensuploaded;
                        $uplo[5] += $numberofspecimensuploaded;
                        $matches_up[17] = $pairuploaded;
                        $matches_up[5] += $pairuploaded;
                        $totals[17] += $numberofspecimens;
                        $totals[5] += $numberofspecimens;}
                elsif ($projectcode eq 'LINC-JP'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[25] = $numberofspecimensuploaded;
                        $uplo[5] += $numberofspecimensuploaded;
                        $matches_up[25] = $pairuploaded;
                        $matches_up[5] += $pairuploaded;
                        $totals[25] += $numberofspecimens;
                        $totals[5] += $numberofspecimens;}
                elsif ($projectcode eq 'PACA-CA'){
                        $marc_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[18] = $numberofspecimensuploaded;
                        $uplo[2] += $numberofspecimensuploaded;
                        $matches_up[18] = $pairuploaded;
                        $matches_up[2] += $pairuploaded;
                        $totals[18] += $numberofspecimens;
                        $totals[2] += $numberofspecimens ;}
                elsif ($projectcode eq 'PRAD-CA'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[26] = $numberofspecimensuploaded;
                        $uplo[2] += $numberofspecimensuploaded;
                        $matches_up[26] = $pairuploaded;
                        $matches_up[2] += $pairuploaded;
                        $totals[26] += $numberofspecimens;
                        $totals[2] += $numberofspecimens ;}
                elsif (substr($projectcode,5,6) eq 'KR'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[7] = $numberofspecimensuploaded;
                        $matches_up[7] = $pairuploaded;
                        $totals[7] += $numberofspecimens;}
                elsif($projectcode eq 'PBCA-DE'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[8] = $numberofspecimensuploaded;
                        $uplo[0] += $numberofspecimensuploaded;
                        $matches_up[8] = $pairuploaded;
                        $matches_up[0] += $pairuploaded;
                        $totals[8] += $numberofspecimens;
                        $totals[0] += $numberofspecimens;}
                elsif($projectcode eq 'MALY-DE'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[9] = $numberofspecimensuploaded;
                        $uplo[0] += $numberofspecimensuploaded;
                        $matches_up[9] = $pairuploaded;
                        $matches_up[0] += $pairuploaded;
                        $totals[9] += $numberofspecimens;
                        $totals[0] += $numberofspecimens;}
                elsif($projectcode eq 'EOPC-DE'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[10] = $numberofspecimensuploaded;
                        $uplo[0] = $numberofspecimensuploaded;
                        $matches_up[10] = $pairuploaded;
                        $matches_up[0] += $pairuploaded;
                        $totals[10] += $numberofspecimens;
                        $totals[0] += $numberofspecimens;}
                elsif($projectcode eq 'BRCA-EU'){
                        $brcaeu_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[11] = $numberofspecimensuploaded;
                        $uplo[1] += $numberofspecimensuploaded;
                        $matches_up[11] = $pairuploaded;
                        $matches_up[1] += $pairuploaded;
                        $totals[11] += $numberofspecimens;
                        $totals[1] += $numberofspecimens;}
                elsif($projectcode eq 'PRAD-UK'){
                        $prad_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[12] = $numberofspecimensuploaded;
                        $uplo[6] += $numberofspecimensuploaded;
                        $matches_up[12] = $pairuploaded;
                        $matches_up[6] += $pairuploaded;
                        $totals[12] += $numberofspecimens;
                        $totals[6] += $numberofspecimens;}
                elsif ($projectcode eq 'ESAD-UK'){
                        $esad_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[13] = $numberofspecimensuploaded;
                        $uplo[1] += $numberofspecimensuploaded;
                        $matches_up[13] = $pairuploaded;
                        $matches_up[1] += $pairuploaded;
                        $totals[13] += $numberofspecimens;
                        $totals[1] += $numberofspecimens;}
                elsif($projectcode eq 'BRCA-UK'){
                        $brca_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[14] = $numberofspecimensuploaded;
                        $uplo[6] += $numberofspecimensuploaded;
                        $matches_up[14] = $pairuploaded;
                        $matches_up[6] += $pairuploaded;
                        $totals[14] += $numberofspecimens;
                        $totals[6] += $numberofspecimens;}
                elsif($projectcode eq 'CMDI-UK'){
                        $cmdi_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[15] = $numberofspecimensuploaded;
                        $uplo[6] += $numberofspecimensuploaded;
                        $matches_up[15] = $pairuploaded;
                        $matches_up[6] += $pairuploaded;
                        $totals[15] += $numberofspecimens;
                        $totals[6] += $numberofspecimens;}
                elsif($projectcode eq 'BOCA-UK'){
                        $boca_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[16] = $numberofspecimensuploaded;
                        $uplo[6] += $numberofspecimensuploaded;
                        $matches_up[16] = $pairuploaded;
                        $matches_up[6] += $pairuploaded;
                        $totals[16] += $numberofspecimens;
                        $totals[6] += $numberofspecimens;}
                elsif($projectcode eq 'ORCA-IN'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[19] = $numberofspecimensuploaded;
                        $matches_up[19] = $pairuploaded;
                        $totals[19] += $numberofspecimens;}
                elsif($projectcode eq 'PACA-AU'){
                        $brca_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[21] = $numberofspecimensuploaded;
                        $uplo[20] += $numberofspecimensuploaded;
                        $matches_up[21] = $pairuploaded;
                        $matches_up[20] += $pairuploaded;
                        $totals[21] += $numberofspecimens;
                        $totals[20] += $numberofspecimens;}
                elsif($projectcode eq 'PAEN-AU'){
                        $cmdi_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[22] = $numberofspecimensuploaded;
                        $uplo[20] += $numberofspecimensuploaded;
                        $matches_up[22] = $pairuploaded;
                        $matches_up[20] += $pairuploaded;
                        $totals[22] += $numberofspecimens;
                        $totals[20] += $numberofspecimens;}
                elsif($projectcode eq 'OV-AU'){
                        $boca_count = $numberofspecimensuploaded;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[23] = $numberofspecimensuploaded;
                        $uplo[20] += $numberofspecimensuploaded;
                        $matches_up[23] = $pairuploaded;
                        $matches_up[20] += $pairuploaded;
                        $totals[23] += $numberofspecimens;
                        $totals[20] += $numberofspecimens;}
                elsif($projectcode eq 'GACA-CN'){
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;
                        $uplo[24] = $numberofspecimensuploaded;
                        $matches_up[24] = $pairuploaded;
                        $totals[24] += $numberofspecimens;}
                elsif($leadjurisdiction ne 'US TCGA'){
                        $missing += $numberofspecimens;
                        $total_icgc += $numberofspecimens;
                        $totals_match += $pledgednumberofwgstnpairs;}
                };


}
close (FILE);

# getting GNOS data straight from pancancer.info
use WWW::Mechanize;
# Create a new mechanize object
my $mech = WWW::Mechanize->new();
my @id = [];
my $counter = 0;
my $uploaded = 0;

# Finding what is uplaoded from the GNOS log files
foreach my $a ("defiles.txt","camfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","hinfiles.txt","krfiles.txt","pbcadefiles.txt","malydefiles.txt","eopcdefiles.txt","brcaeufiles.txt","pradukfiles.txt","esadukfiles.txt","brcaukfiles.txt","cmdiukfiles.txt","bocaukfiles.txt","lirijpfiles.txt","pacacafiles.txt","orcainfiles.txt",,"aufiles.txt","pacaaufiles.txt","paenaufiles.txt","ovaufiles.txt","gacacnfiles.txt"){
foreach my $i ("gtrepo-bsc", "gtrepo-dkfz", "gtrepo-osdc-icgc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {

                @id = [];
                my $url = "http://pancancer.info/log_train/1${i}.log";
                # Associate the mechanize object with a URL
                $mech->get($url);
                
                # Print the content of the URL
                my $results = index ($url, "gtrepo");
                my $fname = substr($url,$results);
                my @content = [];
                
                # makes log files for every repo
                open(my $fh, '>', "/home/ubuntu/brian/public-workflows/decider-bwa-pancancer/1${i}.log") or die ("Could not open ${i}.log");
                print $fh $mech->content;
                close $fh;
                my @line;

                # Load URL::Escape to escape URI's with uri_escape method.
                use URI::Escape;
                my @links = $mech->links;
                foreach my $link (@links) {
                    print uri_escape($link->url), "\n";
                }

                # reads the log files and finds the specimen_id
                open(FH,"/home/ubuntu/brian/public-workflows/decider-bwa-pancancer/1${i}.log") or die ("Could not open ${i}.log");
                while (my $line = <FH>) {
                 my $result = index($line, "SPECIMEN/SAMPLE:");
                 if ($result == 1){
                         push(@id, substr($line,$result+17));
                }
                }
                my $total_files = 0;
                # checks if the specimen_id's are in any repo
                open (FILE, "$path/results/${a}") or die ("Could not open ${a}");
                while (<FILE>) {
                        chomp;
                        ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
                        # if it is found, update the data
                        if (grep( m/$submitter_specimen_id/, @id) && $submitter_specimen_id ne ''){
                          $uploaded += 1;
                           my $ress = index($Normal_Tumor_Designation,'tumour');
                           my $ress1 = index($Normal_Tumor_Designation,'normal');
                           if ($Normal_Tumor_Designation eq 'tumour' || $Normal_Tumor_Designation eq 'Tumor' || $ress != -1){$tumour[$counter] += 1;}
                            elsif ($Normal_Tumor_Designation eq 'normal' || $Normal_Tumor_Designation eq 'Normal' || $ress1 != -1) {$normal[$counter] += 1;}}

                         if ($Study ne "Study" and $Study ne ""){
                          $total_files += 1;}
                }
                close (FILE);
                $totals2[$counter] = $total_files;
        }
        # updates the uploads array 
        $uploads[$counter] = $uploaded;
        $counter += 1;
        $uploaded = 0;
}

# fixes those that do not contain anything
my $o = 0;
for ($o = 0; $o < scalar @tumour; $o++){
        if ($tumour[$o] != 0){$tumour[$o] = $tumour[$o];}
        else {$tumour[$o] = 0};
}

my $e;
for ($e = 0;$e < scalar @uplo;$e++){
        if($uploads[$e] < $uplo[$e]){$uploads[$e] = $uplo[$e];}
}

my $y;
for ($y=0 ; $y < scalar @totals; $y++){
        if ($totals[$y] < $totals2[$y]){$totals[$y] = $totals2[$y];}
}

if ($totals[24] < $totals2[24]){$totals[24] = $totals2[24];}

$totals[0] = $totals[8] + $totals[9] + $totals[10];
$totals[1] = $totals[11] + $totals[13];
$uploads[1] = $uploads[11] + $uploads[13];
$totals[2] = $totals[18] + $totals[26];
$totals[5] = $totals[17] + $totals[25];
$totals[6] = $totals[12] + $totals[14] + $totals[15] + $totals[16];
$totals[20] = $totals[21] + $totals[22] + $totals[23];
$total_icgc = $totals[0] + $totals[1] + $totals[2] + $totals[3] + $totals[4] + $totals[5] + $totals[6] + $totals[7] + $totals[20] + $totals[19] + $totals[24] + $missing;

# applying colors and radius to each bubble, as long as getting the average
my $h = 0;
for ($h = 0; $h < scalar @totals; $h++){
        print "$totals[$h] : $h\n";
        $ave[$h] = ($uploads[$h]/$totals[$h])*100;

        if ($ave[$h] <= 15.0 && $ave[$h] >= 0.0){$col[$h] = "red";}
                elsif ($ave[$h] <= 80.0 && $ave[$h] > 15.0){$col[$h] = "yellow";}
                else {$col[$h] = "green";};

        if($totals[$h] <= 120 && $totals[$h] >=0){$rad[$h] = 15;}
                elsif($totals[$h] <= 500 && $totals[$h] >=120){$rad[$h] = 20;}
                elsif($totals[$h] <= 500 && $totals[$h] >=800){$rad[$h] = 25;}
                else{$rad[$h] = 30;};

        $size[$h] = $rad[$h]*$ave[$h]/100;
        if ($size[$h] >= 0.0 && $size[$h] < 3){$size[$h] = 3;};
}

my $num;
my %match;
my @match_pair;

# finding the matched tumour/normal pairs

# gets an array of all the specimen ids that are uplaoded
foreach my $i ("gtrepo-bsc","gtrepo-dkfz", "gtrepo-osdc-icgc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {
  my $url = "http://pancancer.info/log_train/1${i}.log";
  # Associate the mechanize object with a URL
  $mech->get($url);
  # Print the content of the URL
  my $results = index ($url, "gtrepo");
  my $fname = substr($url,$results);
  my @content = [];
  # makes log files for every repo
  open(my $fh, '>', "/home/ubuntu/brian/public-workflows/decider-bwa-pancancer/1${i}.log") or die ("Could not open ${i}.log");
  print $fh $mech->content;
  close $fh;
  my @line;

  # Load URL::Escape to escape URI's with uri_escape method.
  use URI::Escape;
  my @links = $mech->links;
  foreach my $link (@links) {
      print uri_escape($link->url), "\n";
  }

  # reads the log files and finds the specimen_id
  open(FH,"/home/ubuntu/brian/public-workflows/decider-bwa-pancancer/1${i}.log") or die ("Could not open ${i}.log");
  while (my $line = <FH>) {
   my $result = index($line, "SPECIMEN/SAMPLE:");
   if ($result == 1){
   push(@id, substr($line,$result+17));
   }
  }
  close(FH);
}

# creates a hash of arrays with the donor id as the key and the specimen ids as the valuees in the arrays
my $count_pass = 0;
foreach my $a ("defiles.txt","camfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","hinfiles.txt","krfiles.txt","pbcadefiles.txt","malydefiles.txt","eopcdefiles.txt","brcaeufiles.txt","pradukfiles.txt","esadukfiles.txt","brcaukfiles.txt","cmdiukfiles.txt","bocaukfiles.txt","lirijpfiles.txt","pacacafiles.txt","orcainfiles.txt","aufiles.txt","pacaaufiles.txt","paenaufiles.txt","ovaufiles.txt","gacacnfiles.txt"){

 my $len;
 my $match_count;
 # print "$count_pass\n";
 $match_count = 0;
 $len = 0;
 for (keys %match)
    {
        delete $match{$_};
    }
 open (FILE, "$path/results/${a}") or die ("Could not open ${a}");
 while (<FILE>) {
 chomp;
 ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
  if ($Study ne "Study" && $Study ne ''){
  push (@{$match{$submitter_donor_id}}, $submitter_specimen_id);
  }
 }
 close (FILE);

# checking if each element in each array is uploaded
foreach my $elems (keys %match){
 $len = 0;
 my $h = 0;
 for ($h = 0;$h < scalar @{$match{$elems}};$h++){
 if (grep( m/$match{$elems}[$h]/, @id) && $match{$elems}[$h] ne ''){
  $len++;
 }
}
if ($len == scalar @{$match{$elems}}){
 $match_count++;}
}
  $match_pair[$count_pass] = $match_count;
  $count_pass += 1;
}

# Fixing PACA-CA count
$uploads[2] += 23;
$uploads[18] += 23;
$match_pair[2] += 12;

my $z;
for ($z = 0;$z < scalar @matches_up;$z++){
        if($match_pair[$z] < $matches_up[$z]){$match_pair[$z] = $matches_up[$z];}
}

$match_pair[1] = $match_pair[11] + $match_pair[13];

# writes to bubble_data.json 
open(my $file,'>', "$path/map-data/bubble_data.json") or die ("Could not open bubble_data.json");
print $file qq([
          {"total_icgc": $total_icgc, "name": "Heidelberg", "total": $totals[0], "uploaded": $uploads[0], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[0], "fillKey": "orange","match_total": $totals_match, "match": $match_pair[0], "tumour": $tumour[0], "normal": $normal[0]},
          {"name": "Heidelberg", "total": $totals[0], "uploaded": $uploads[0], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[0], "fillKey": "$col[0]"},       
          {"name": "Cambridge", "total": $totals[1], "uploaded": $uploads[1], "latitude": 52.202544, "longitude": 0.131237 , "radius": $rad[1], "fillKey": "orange","match": $match_pair[1],"tumour": $tumour[1], "normal": $normal[1]},
          {"name": "Cambridge", "total": $totals[1], "uploaded": $uploads[1], "latitude": 52.202544, "longitude": 0.131237 , "radius": $size[1], "fillKey": "$col[1]"},
          
          {"name": "Hinxton", "total": $totals[6], "uploaded": $uploads[6], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[6], "fillKey": "orange", "match": $match_pair[6],"tumour": $tumour[6], "normal": $normal[6]},
          {"name": "Hinxton", "total": $totals[6], "uploaded": $uploads[6], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[6], "fillKey": "$col[6]"},
          
          {"name": "Toronto", "total": $totals[2], "uploaded": $uploads[2], "latitude": 43.7000, "longitude": -79.4000, "radius": $rad[2], "fillKey": "orange","match": $match_pair[2], "tumour": $tumour[2], "normal": $normal[2]},
          {"name": "Toronto", "total": $totals[2], "uploaded": $uploads[2], "latitude": 43.7000, "longitude": -79.4000, "radius": $size[2], "fillKey": "$col[2]"},
     
          {"name": "Barcelona", "total": $totals[3], "uploaded": $uploads[3], "latitude": 41.378691, "longitude": 2.175547, "radius": $rad[3], "fillKey": "orange","match": $match_pair[3], "tumour": $tumour[3], "normal": $normal[3],"project": "CLLE-ES"},
          {"name": "Barcelona", "total": $totals[3], "uploaded": $uploads[3], "latitude": 41.378691, "longitude": 2.175547, "radius": $size[3], "fillKey": "$col[3]","project": "CLLE-ES"},

          {"name": "Singapore", "total": $totals[4], "uploaded": $uploads[4], "latitude": 1.2896700, "longitude": 103.8500700, "radius": $rad[4], "fillKey": "orange","match": $match_pair[4], "tumour": $tumour[4], "normal": $normal[4],"project": "BTCA-SG"},
          {"name": "Singapore", "total": $totals[4], "uploaded": $uploads[4], "latitude": 1.2896700, "longitude": 103.8500700, "radius": $size[4], "fillKey": "$col[4]","project": "BTCA-SG"},
          
          {"name": "Seoul", "total": $totals[7], "uploaded": $uploads[7], "latitude": 37.532600, "longitude": 127.024612, "radius": $rad[7], "fillKey": "orange","match": $match_pair[7], "tumour": $tumour[7], "normal": $normal[7],"project": "LAML-KR"},
          {"name": "Seoul", "total": $totals[7], "uploaded": $uploads[7], "latitude": 37.532600, "longitude": 127.024612, "radius": $size[7], "fillKey": "$col[7]","project": "LAML-KR"},

          {"name": "Kalyani", "total": $totals[19], "uploaded": $uploads[19], "latitude": 22.98000, "longitude": 88.44000, "radius": $rad[19], "fillKey": "orange","match": $match_pair[19], "tumour": $tumour[19], "normal": $normal[19]},
{"name": "Kalyani", "total": $totals[19], "uploaded": $uploads[19], "latitude": 22.98000,  "longitude": 88.44000, "radius": $size[19], "fillKey": "$col[19]"},

	  {"name": "Brisbane", "total": $totals[20], "uploaded": $uploads[20], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $rad[20], "fillKey": "orange","match": $match_pair[20]},
          {"name": "Brisbane", "total": $totals[20], "uploaded": $uploads[20], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $size[20], "fillKey": "$col[20]"},
          
          {"name": "Beijing", "total": $totals[24], "uploaded": $uploads[24], "latitude": 39.9139, "longitude": 116.3917, "radius": $rad[24], "fillKey": "orange","match": $match_pair[24], "project": "GACA-CN"},
          {"name": "Beijing", "total": $totals[24], "uploaded": $uploads[24], "latitude": 39.9139, "longitude": 116.3917, "radius": $size[24], "fillKey": "$col[24]", "project": "GACA-CN"},

          {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $rad[5], "fillKey": "orange","match": $match_pair[5], "tumour": $tumour[5], "normal": $normal[5]},
          {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $size[5], "fillKey": "$col[5]"}


]);
close $file;

# writes to bubble_data1.json
open(my $file_add,'>', "$path/map-data/bubble_data1.json") or die ("Could not open bubble_data.json");
print $file_add qq([
        {"name": "Heidelberg", "total": $totals[8], "uploaded": $uploads[8], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[8], "fillKey": "orange","match": $match_pair[8], "tumour": $tumour[8], "normal": $normal[8], "project": "PBCA-DE"},
        {"name": "Heidelberg", "total": $totals[8], "uploaded": $uploads[8], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[8], "fillKey": "$col[8]", "project": "PBCA-DE"},
        
        {"name": "Heidelberg", "total": $totals[9], "uploaded": $uploads[9], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[9], "fillKey": "orange","match": $match_pair[9], "tumour": $tumour[9], "normal": $normal[9], "project": "MALY-DE"},
        {"name": "Heidelberg", "total": $totals[9], "uploaded": $uploads[9], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[9], "fillKey": "$col[9]", "project": "MALY-DE"},
        
        {"name": "Heidelberg", "total": $totals[10], "uploaded": $uploads[10], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[10], "fillKey": "orange","match": $match_pair[10], "tumour": $tumour[10], "normal": $normal[10], "project": "EOPC-DE"},
        {"name": "Heidelberg", "total": $totals[10], "uploaded": $uploads[10], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[10], "fillKey": "$col[10]", "project": "EOPC-DE"},
        
        {"name": "Hinxton", "total": $totals[12], "uploaded": $uploads[12], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[12], "fillKey": "orange","match": $match_pair[12], "tumour": $tumour[12], "normal": $normal[12], "project": "PRAD-UK"},
        {"name": "Hinxton", "total": $totals[12], "uploaded": $uploads[12], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[12], "fillKey": "$col[12]", "project": "PRAD-UK"},
        
        {"name": "Hinxton", "total": $totals[14], "uploaded": $uploads[14], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[14], "fillKey": "orange","match": $match_pair[14], "tumour": $tumour[14], "normal": $normal[14], "project": "BRCA-UK"},
        {"name": "Hinxton", "total": $totals[14], "uploaded": $uploads[14], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[14], "fillKey": "$col[14]", "project": "BRCA-UK"},
        
        {"name": "Hinxton", "total": $totals[15], "uploaded": $uploads[15], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[15], "fillKey": "orange","match": $match_pair[15], "tumour": $tumour[15], "normal": $normal[15], "project": "CMDI-UK"},
        {"name": "Hinxton", "total": $totals[15], "uploaded": $uploads[15], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[15], "fillKey": "$col[15]", "project": "CMDI-UK"},
        
        {"name": "Hinxton", "total": $totals[16], "uploaded": $uploads[16], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[16], "fillKey": "orange","match": $match_pair[16], "tumour": $tumour[16], "normal": $normal[16], "project": "BOCA-UK"},
        {"name": "Hinxton", "total": $totals[16], "uploaded": $uploads[16], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[16], "fillKey": "$col[16]", "project": "BOCA-UK"},
        
        {"name": "Toronto", "total": $totals[18], "uploaded": $uploads[18], "latitude": 43.7000, "longitude": -79.4000, "radius": $rad[18], "fillKey": "orange","match": $match_pair[2], "tumour": $tumour[2], "normal": $normal[2], "project": "PACA-CA"},
        {"name": "Toronto", "total": $totals[18], "uploaded": $uploads[18], "latitude": 43.7000, "longitude": -79.4000, "radius": $size[18], "fillKey": "$col[18]", "project": "PACA-CA"},
        
        {"name": "Tokyo", "total": $totals[17], "uploaded": $uploads[17], "latitude": 35.684219, "longitude": 139.755020, "radius": $rad[17], "fillKey": "orange","match": $match_pair[5], "tumour": $tumour[5], "normal": $normal[5], "project": "LIRI-JP"},
        {"name": "Tokyo", "total": $totals[17], "uploaded": $uploads[17], "latitude": 35.684219, "longitude": 139.755020, "radius": $size[17], "fillKey": "$col[17]", "project": "LIRI-JP"},
        
        {"name": "Kalyani", "total": $totals[19], "uploaded": $uploads[19], "latitude": 22.98000, "longitude": 88.44000, "radius": $rad[19], "fillKey": "orange","match": $match_pair[19], "tumour": $tumour[19], "normal": $normal[19],"project": "ORCA-IN"},
{"name": "Kalyani", "total": $totals[19], "uploaded": $uploads[19], "latitude": 22.98000,  "longitude": 88.44000, "radius": $size[19], "fillKey": "$col[19]","project": "ORCA-IN"},

	{"name": "Brisbane", "total": $totals[21], "uploaded": $uploads[21], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $rad[21], "fillKey": "orange", "match": $match_pair[21], "project": "PACA-AU"},
        {"name": "Brisbane", "total": $totals[21], "uploaded": $uploads[21], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $size[21], "fillKey": "$col[21]", "project": "PACA-AU"},
          
        {"name": "Brisbane", "total": $totals[22], "uploaded": $uploads[22], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $rad[22], "fillKey": "orange","match": $match_pair[22], "project": "PAEN-AU"},
        {"name": "Brisbane", "total": $totals[22], "uploaded": $uploads[22], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $size[22], "fillKey": "$col[22]", "project": "PAEN-AU"},
          
        {"name": "Brisbane", "total": $totals[23], "uploaded": $uploads[23], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $rad[23], "fillKey": "orange","match": $match_pair[20], "project": "OV-AU"},
        {"name": "Brisbane", "total": $totals[23], "uploaded": $uploads[23], "latitude": -27.4679400, "longitude": 153.0280900, "radius": $size[23], "fillKey": "$col[23]", "project": "OV-AU"},
        
        {"name": "Cambridge", "total": $totals[13], "uploaded": $uploads[13], "latitude": 52.202544, "longitude": 0.131237 , "radius": $rad[13], "fillKey": "orange","match": $match_pair[13],"tumour": $tumour[13], "normal": $normal[13], "project": "ESAD-UK"},
        {"name": "Cambridge", "total": $totals[13], "uploaded": $uploads[13], "latitude": 52.202544, "longitude": 0.131237 , "radius": $size[13], "fillKey": "$col[13]", "project": "ESAD-UK"},
        
        {"name": "Cambridge", "total": $totals[11], "uploaded": $uploads[11], "latitude": 52.202544, "longitude": 0.131237 , "radius": $rad[11], "fillKey": "orange","match": $match_pair[11],"tumour": $tumour[11], "normal": $normal[11], "project": "BRCA-EU"},
        {"name": "Cambridge", "total": $totals[11], "uploaded": $uploads[11], "latitude": 52.202544, "longitude": 0.131237 , "radius": $size[11], "fillKey": "$col[11]", "project": "BRCA-EU"},
]);
close $file;

use POSIX qw(strftime);

my $date = strftime "%a %b %d '%y - %R", localtime;

# updates the average data for the chart
# appending to file with all average data
open(my $f, '>>', "$path/map-data/ave_data_archive.csv") or die ("Could not open ave_data_archive.csv");
print $f "$date,";
my $k = 0;
my $count1 = 0;
for ($k = 0; $k < scalar @totals - 19; $k++){
        if ($count1 >= 0 && $count1 < scalar @totals -20){printf $f "%.3f,", $ave[$k];}
        else {printf $f "%.3f,", $ave[$k];}
        $count1 += 1;
}
printf $f "%.3f,", $ave[19];
printf $f "%.3f,", $ave[20];
printf $f "%.3f,", $ave[24];
print $f "100.000\n";
close $f;

# updates the total uploads for the chart
# appending to file with all upload data
open(my $f1, '>>', "$path/map-data/up_data_archive.csv") or die ("Could not open up_data_archive.csv");
print $f1 "$date,";
my $r = 0;
my $count2 = 0;
for ($r = 0; $r < scalar @totals - 19; $r++){
        if ($count2 >= 0 && $count2 < scalar @totals - 20){printf $f1 "%.3f,", $uploads[$r];}
        else {printf $f1 "%.3f,", $uploads[$r];}
        $count2 += 1;
}
printf $f1 "%.3f,", $uploads[19];
printf $f1 "%3f,", $uploads[20];
printf $f1 "%3f,", $uploads[24];
print $f1 "1874\n";
close $f1;


my @ary = [];
my $count_ave = 0;
my @ary1 = [];
my $count_up = 0;
my @day_ary1 = [];
my $count_day1 = 0;
my @day_ary2 = [];
my $count_day2 = 0;

# finding number of rows in the archived data
open(FH,"$path/map-data/ave_data_archive.csv") or die("Can't open ave_data_archive.csv");
while (my $line = <FH>) {
    $count_ave += 1;
    push (@ary,"$line");
    my $result = index($line,'Mon');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary1,$line);
           $count_day1 ++;}
    elsif($result1 != -1){push (@day_ary1,$line);}
}
close(FH);

# only displaying 20 lines on the chart for hourly
open(my $file_ave, '>',"$path/map-data/ave_data.csv") or die("Can't open ave_data.csv");
if ($count_ave > 21){
        my $h = 0;
        print $file_ave $ary[1];
        for ($h = $count_ave -19; $h < $count_ave +1;$h++){
                print $file_ave $ary[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_ave +1;$p++){
                print $file_ave $ary[$p];
        }
};
close $file_ave;

# only displaying 20 lines for daily
open(my $file_ave2, '>',"$path/map-data/ave_daily.csv") or die("Can't open ave_daily.csv");
if ($count_day1 > 20){
        my $h = 0;
        print $file_ave2 $day_ary1[1];
        for ($h = $count_day1 -19; $h < $count_day1 +2;$h++){
                my $result = index($day_ary1[$h],'Mon');
                if ($result != -1){
                print $file_ave2 $day_ary1[$h];
        }
}
}
else {
        print $file_ave2 $day_ary1[1];
        my $p = 0;
        for ($p = 0; $p < $count_day1 +2;$p++){
                my $result = index($day_ary1[$p],'Mon');
                if ($result != -1){
                print $file_ave2 $day_ary1[$p];
        }}
};
close $file_ave2;

# finding number of rows in the archived data
open(FH,"$path/map-data/up_data_archive.csv") or die("Can't open up_data_archive.csv");
while (my $line = <FH>) {
    $count_up += 1;
    push (@ary1,"$line");
    my $result = index($line,'Mon');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary2,$line);
           $count_day2 ++;}
    elsif($result1 != -1){push (@day_ary2,$line);}
}
close(FH);

# only displaying 20 lines on the chart for hourly 
open(my $file_up, '>',"$path/map-data/up_data.csv") or die("Can't open up_data.csv");
if ($count_up > 21){
        my $h = 0;
        print $file_up $ary1[1];
        for ($h = $count_up - 19; $h < $count_up +1;$h++){
                print $file_up $ary1[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_up +1;$p++){
                print $file_up $ary1[$p];
        }
};
close $file_up;

# only displaying 20 lines for daily
open(my $file_up2, '>',"$path/map-data/up_daily.csv") or die("Can't open ave_daily.csv");
if ($count_day2 > 21){
        my $h = 0;
        print $file_up2 $day_ary2[1];
        for ($h = $count_day2 -19; $h < $count_day2 +2;$h++){
                my $result = index($day_ary2[$h],'Mon');
                if ($result != -1){
                print $file_up2 $day_ary2[$h];
        }
}
}
else {
        print $file_up2 $day_ary2[1];
        my $p = 0;
        for ($p = 0; $p < $count_day2 +2;$p++){
                my $result = index($day_ary2[$p],'Mon');
                if ($result != -1){
                print $file_up2 $day_ary2[$p];
        }}
};
close $file_up2;

# writing to the data needed for the individual repo line graphs
foreach my $thing ('DKFZ','EBI','BSC','RIKEN','OSDC','ETRI'){
        open(my $file, '>>', "$path/map-data/${thing}_up_archive.csv") or die ("Can't open ${thing}_up_archive.csv") ;
        open(my $filea, '>>', "$path/map-data/${thing}_ave_archive.csv") or die ("Can't open ${thing}_ave_archive.csv");
        if ($thing eq 'DKFZ'){
                #print $file "quarter,PBCA-DE,MALY-DE,EOPC-DE\n";
                #print $filea "quarter,PBCA-DE,MALY-DE,EOPC-DE\n";
                printf $file "$date,%.3f,%.3f,%.3f\n", $uploads[8],$uploads[9],$uploads[10];
                printf $filea "$date,%.3f,%.3f,%.3f\n", $ave[8],$ave[9],$ave[10];}
        elsif ($thing eq 'EBI'){
                #print $file "quarter,BRCA-UK,CMDI-UK,BOCA-UK,PRAD-UK,ESAD-UK,BRCA-EU,PACA-CA,PACA-AU,PAEN-AU,OV-AU\n";
                #print $filea "quarter,BRCA-UK,CMDI-UK,BOCA-UK,PRAD-UK,ESAD-UK,BRCA-EU,PACA-CA,PACA-AU,PAEN-AU,OV-AU\n";
                printf $file "$date,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f\n", $uploads[14],$uploads[15],$uploads[16],$uploads[12],$uploads[13],$uploads[11],$uploads[18],$uploads[21],$uploads[22],$uploads[23];
                printf $filea "$date,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f\n", $ave[14],$ave[15],$ave[16],$ave[12],$ave[13],$ave[11],$ave[18],$ave[21],$ave[22],$ave[23];}
        elsif ($thing eq 'BSC'){
                #print $file "quarter,CLLE-ES\n";
                #print $filea "quarter,CLLE-ES\n";
                printf $file "$date,%.3f\n", $uploads[3];
                printf $filea "$date,%.3f\n", $ave[3];}
        elsif ($thing eq 'RIKEN'){
                #print $file "quarter,BTCA-SG,LIRI-JP,ORCA-IN,GACA-CN\n";
                #print $filea "quarter,BTCA-SG,LIRI-JP,ORCA-IN,GACA-CN\n";
                printf $file "$date,%.3f,%.3f,%.3f,%.3f\n", $uploads[4],$uploads[5],$uploads[19],$uploads[24];
                printf $filea "$date,%.3f,%.3f,%.3f,%.3f\n", $ave[4],$ave[5],$ave[19],$ave[24];}
        elsif ($thing eq 'OSDC'){
                #print $file "quarter\n";
                #print $filea "quarter\n";
                printf $file "$date\n";
                printf $filea "$date\n";}
        elsif ($thing eq 'ETRI'){
                #print $file "quarter,LAML-KR\n";
                #print $filea "quarter,LAML-KR\n";
                printf $file "$date,%.3f\n", $uploads[7];
                printf $filea "$date,%.3f\n", $ave[7];}
        close $file;
        close $filea;
        }

foreach my $elems ('DKFZ','EBI','BSC','OSDC','RIKEN','ETRI'){
my @aryre = [];
my $count_avere = 0;
my @ary1re = [];
my $count_upre = 0;
my @day_ary1re = [];
my $count_day1re = 0;
my @day_ary2re = [];
my $count_day2re = 0;

# finding number of rows in the archived data
open(FH,"$path/map-data/${elems}_ave_archive.csv") or die ("Can't open ${elems}_ave_archive.csv");
while (my $line = <FH>) {
    $count_avere += 1;
    push (@aryre,"$line");
    my $result = index($line,'Mon');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary1re,$line);
           $count_day1re ++;}
    elsif($result1 != -1){push (@day_ary1,$line);}
}
close(FH);

# only displaying 20 lines on the chart for hourly
open(my $file_ave, '>',"$path/map-data/${elems}_ave_data.csv") or die ("Can't open ${elems}_ave_data.csv");
if ($count_avere > 21){
        my $h = 0;
        print $file_ave $aryre[1];
        for ($h = $count_avere -19; $h < $count_avere +1;$h++){
                print $file_ave $aryre[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_avere +1;$p++){
                print $file_ave $aryre[$p];
        }
};
close $file_ave;

open(FH,"$path/map-data/${elems}_up_archive.csv") or die ("Can't open ${elems}_up_archive.csv");
while (my $line = <FH>) {
    $count_upre += 1;
    push (@ary1re,"$line");
    my $result = index($line,'Mon');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary2re,$line);
           $count_day2re ++;}
    elsif($result1 != -1){push (@day_ary2re,$line);}
}
close(FH);
# only displaying 20 lines on the chart for hourly 
open(my $file_up, '>',"$path/map-data/${elems}_up_data.csv") or die ("Can't open ${elems}_up_data.csv");
if ($count_upre > 21){
        my $h = 0;
        print $file_up $ary1re[1];
        for ($h = $count_upre - 19; $h < $count_upre +1;$h++){
                print $file_up $ary1re[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_upre +1;$p++){
                print $file_up $ary1re[$p];
        }
};
close $file_up;
}

exit;
