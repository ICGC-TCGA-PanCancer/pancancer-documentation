#!/usr/bin/perl -T

use strict;
use warnings;

use JSON 2;
use IO::Handle;

my ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual);

my ($all_emp_count, $all_fill_count) = (0)x2;

#For all the arrays 
#[0]=Heidelberg,[1]=Cambridge,[2]=Toronto,[3]=Barcelona,[4]=Singapore,[5]=Tokyo,[6]=Hinxton,[7]=Seoul

my @fill_counts = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @emp_counts = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @col = ("","","","","","","","","","","","","","");
my @rad = (0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @size = (0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @ave = (0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @uploads = (0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @tumour = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @normal = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

my ($projectcode,$leadjurisdiction,$tumourtype,$gnos,$numberofwgstnpairs,$numberofspecimens,$numberofspecimensuploaded,$percentuploaded);
my @totals;

#reading from text file containing summary of all the projects
#individual project text files created from get_uplaods.pl
open (FILE, "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/results/summary.txt") or die ("Could not open summary.txt");
while (<FILE>) {
chomp;
($projectcode,$leadjurisdiction,$tumourtype,$gnos,$numberofwgstnpairs,$numberofspecimens,$numberofspecimensuploaded,$percentuploaded) = split("\t");

if ($projectcode ne 'Project Code' && $projectcode ne ''){
		if (substr($projectcode,5,6) eq 'SG'){
			$totals[4] += $numberofspecimens;}
		elsif (substr($projectcode,5,6) eq 'ES'){
			$totals[3] += $numberofspecimens;}
		elsif ($projectcode eq 'LIRI-JP'){
			$totals[17] += $numberofspecimens;
			$totals[5] += $numberofspecimens;}
		elsif ($projectcode eq 'LINC-JP'){
			$totals[19] += $numberofspecimens;
			$totals[5] += $numberofspecimens;}
		elsif ($projectcode eq 'PACA-CA'){
			$totals[18] += $numberofspecimens;
			$totals[2] += $numberofspecimens ;}
		elsif ($projectcode eq 'PRAD-CA'){
			$totals[20] += $numberofspecimens;
			$totals[2] += $numberofspecimens ;}
		elsif (substr($projectcode,5,6) eq 'KR'){
			$totals[7] += $numberofspecimens;}
		elsif($projectcode eq 'PBCA-DE'){
			$totals[8] += $numberofspecimens;
			$totals[0] += $numberofspecimens;}
		elsif($projectcode eq 'MALY-DE'){
			$totals[9] += $numberofspecimens;
			$totals[0] += $numberofspecimens;}
		elsif($projectcode eq 'EOPC-DE'){
			$totals[10] += $numberofspecimens;
			$totals[0] += $numberofspecimens;}
		elsif($projectcode eq 'BRCA-EU'){
			$totals[11] += $numberofspecimens;
			$totals[1] += $numberofspecimens;}
		elsif($projectcode eq 'PRAD-UK'){
			$totals[12] += $numberofspecimens;
			$totals[6] += $numberofspecimens;}
		elsif ($projectcode eq 'ESAD-UK'){
			$totals[13] += $numberofspecimens;
			$totals[1] += $numberofspecimens;}
		elsif($projectcode eq 'BRCA-UK'){
			$totals[14] += $numberofspecimens;
			$totals[6] += $numberofspecimens;}
		elsif($projectcode eq 'CMDI-UK'){
			$totals[15] += $numberofspecimens;
			$totals[6] += $numberofspecimens;}
		elsif($projectcode eq 'BOCA-UK'){
			$totals[16] += $numberofspecimens;
			$totals[6] += $numberofspecimens;}
		};
}
close (FILE);

#getting GNOS data straight from pancancer.info
use WWW::Mechanize;
# Create a new mechanize object
my $mech = WWW::Mechanize->new();
my @id = [];
my $counter = 0;
my $uploaded = 0;

#Finding what is uplaoded from the GNOS log files
foreach my $a ("defiles.txt","camfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","hinfiles.txt","krfiles.txt","pbcadefiles.txt","malydefiles.txt","eopcdefiles.txt","brcaeufiles.txt","pradukfiles.txt","esadukfiles.txt","brcaukfiles.txt","cmdiukfiles.txt","bocaukfiles.txt","lirijpfiles.txt","pacacafiles.txt"){
foreach my $i ("gtrepo-bsc", "gtrepo-dkfz", "gtrepo-osdc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {

                @id = [];
                my $url = "http://pancancer.info/${i}.log";
                # Associate the mechanize object with a URL
                $mech->get($url);
                
                # Print the content of the URL
                my $results = index ($url, "gtrepo");
                my $fname = substr($url,$results);
                my @content = [];
                
                #makes log files for every repo
                open(my $fh, '>', "${i}.log") or die ("Could not open ${i}.log");
                print $fh $mech->content;
                close $fh;
                my @line;

                # Load URL::Escape to escape URI's with uri_escape method.
                use URI::Escape;
                my @links = $mech->links;
                foreach my $link (@links) {
                    print uri_escape($link->url), "\n";
                }

                #reads the log files and finds the specimen_id
                open(FH,"${i}.log") or or die ("Could not open ${i}.log");
                while (my $line = <FH>) {
                 my $result = index($line, "SPECIMEN/SAMPLE:");
                 if ($result == 1){
                         push(@id, substr($line,$result+17));
                }
                }
                my $total_files = 0;
                #checks if the specimen_id's are in any repo
                open (FILE, "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/results/${a}") or die ("Could not open ${a}");
                while (<FILE>) {
                        chomp;
                        ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
                        #if it is found, update the data
                        if (grep( /^$submitter_specimen_id$/, @id) && $submitter_specimen_id ne ''){
                          $uploaded += 1;
                           my $ress = index($Normal_Tumor_Designation,'tumour');
                           my $ress1 = index($Normal_Tumor_Designation,'normal');
                           if ($Normal_Tumor_Designation eq 'tumour' || $Normal_Tumor_Designation eq 'Tumor' || $ress != -1){$tumour[$counter] += 1;}
                            elsif ($Normal_Tumor_Designation eq 'normal' || $Normal_Tumor_Designation eq 'Normal' || $ress1 != -1) {$normal[$counter] += 1;}}

                         if ($Study ne "Study"){
                          $total_files += 1;}
                }
                close (FILE);
        }
        #updates the uploads array 
        $uploads[$counter] = $uploaded;
        $counter += 1;
        $uploaded = 0;
}

#fixes those that do not contain anything
my $o = 0;
for ($o = 0; $o < scalar @tumour; $o++){
        if ($tumour[$o] != 0){$tumour[$o] = $tumour[$o];}
        else {$tumour[$o] = 0};
}


#applying colors and radius to each bubble, also getting the average
my $h = 0;
for ($h = 0; $h < scalar @totals; $h++){
        $ave[$h] = $uploads[$h]/$totals[$h];

        if ($ave[$h] <= .15 && $ave[$h] >= 0.0){$col[$h] = "red";}
                elsif ($ave[$h] <= .80 && $ave[$h] > .15){$col[$h] = "yellow";}
                else {$col[$h] = "green";};

        if($totals[$h] <= 120 && $totals[$h] >=0){$rad[$h] = 15;}
                elsif($totals[$h] <= 500 && $totals[$h] >120){$rad[$h] = 20;}
                elsif($totals[$h] <= 800 && $totals[$h] >500){$rad[$h] = 25;}
                else{$rad[$h] = 30;};

        $size[$h] = $rad[$h]*$ave[$h];
        if ($size[$h] >= 0.0 && $size[$h] < 3){$size[$h] = 3;};
}

my $num;
my %match;
my @match_pair;

#finding the matched tumour/normal pairs

#gets an array of all the specimen ids that are uplaoded
foreach my $i ("gtrepo-bsc","gtrepo-dkfz", "gtrepo-osdc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {
  my $url = "http://pancancer.info/${i}.log";
  # Associate the mechanize object with a URL
  $mech->get($url);
  # Print the content of the URL
  my $results = index ($url, "gtrepo");
  my $fname = substr($url,$results);
  my @content = [];
  #makes log files for every repo
  open(my $fh, '>', "${i}.log") or die ("Could not open ${i}.log");
  print $fh $mech->content;
  close $fh;
  my @line;

  # Load URL::Escape to escape URI's with uri_escape method.
  use URI::Escape;
  my @links = $mech->links;
  foreach my $link (@links) {
      print uri_escape($link->url), "\n";
  }

  #reads the log files and finds the specimen_id
  open(FH,"${i}.log") or die ("Could not open ${i}.log");
  while (my $line = <FH>) {
   my $result = index($line, "SPECIMEN/SAMPLE:");
   if ($result == 1){
   push(@id, substr($line,$result+17));
   }
  }
  close(FH);
}

#creates a hash of arrays with the donor id as the key and the specimen ids as the valuees in the arrays
my $count_pass = 0;
foreach my $a ("defiles.txt","camfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","hinfiles.txt","krfiles.txt","pbcadefiles.txt","malydefiles.txt","eopcdefiles.txt","brcaeufiles.txt","pradukfiles.txt","esadukfiles.txt","brcaukfiles.txt","cmdiukfiles.txt","bocaukfiles.txt","lirijpfiles.txt","pacacafiles.txt"){

 my $len;
 my $match_count;
 # print "$count_pass\n";
 $match_count = 0;
 $len = 0;
 for (keys %match)
    {
        delete $match{$_};
    }
 open (FILE, "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/results/${a}") or die ("Could not open ${a}");
 while (<FILE>) {
 chomp;
 ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
  if ($Study ne "Study" && $Study ne ''){
  push (@{$match{$submitter_donor_id}}, $submitter_specimen_id);
  }
 }
 close (FILE);

#checking if each element in each array is uploaded
foreach my $elems (keys %match){
 $len = 0;
 my $h = 0;
 for ($h = 0;$h < scalar @{$match{$elems}};$h++){
 if (grep( /^$match{$elems}[$h]$/, @id) && $match{$elems}[$h] ne ''){
  $len++;
 }
}
if ($len == scalar @{$match{$elems}}){
 $match_count++;}
}
  $match_pair[$count_pass] = $match_count;
  $count_pass += 1;
}


#writes to bubble_data.json 
open(my $file,'>', "~/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data.json") or die ("Could not open bubble_data.json");
print $file qq([
        {"name": "Heidelberg", "total": $totals[0], "uploaded": $uploads[0], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[0], "fillKey": "orange","match": $match_pair[0], "tumour": $tumour[0], "normal": $normal[0]},
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

        {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $rad[5], "fillKey": "orange","match": $match_pair[5], "tumour": $tumour[5], "normal": $normal[5]},
        {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $size[5], "fillKey": "$col[5]"}

]);
close $file;

#writes to bubble_data1.json
open(my $file_add,'>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data1.json") or die ("Could not open bubble_data.json");
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
        
        {"name": "Cambridge", "total": $totals[13], "uploaded": $uploads[13], "latitude": 52.202544, "longitude": 0.131237 , "radius": $rad[13], "fillKey": "orange","match": $match_pair[13],"tumour": $tumour[13], "normal": $normal[13], "project": "ESAD-UK"},
        {"name": "Cambridge", "total": $totals[13], "uploaded": $uploads[13], "latitude": 52.202544, "longitude": 0.131237 , "radius": $size[13], "fillKey": "$col[13]", "project": "ESAD-UK"},
        
        {"name": "Cambridge", "total": $totals[11], "uploaded": $uploads[11], "latitude": 52.202544, "longitude": 0.131237 , "radius": $rad[11], "fillKey": "orange","match": $match_pair[11],"tumour": $tumour[11], "normal": $normal[11], "project": "BRCA-EU"},
        {"name": "Cambridge", "total": $totals[11], "uploaded": $uploads[11], "latitude": 52.202544, "longitude": 0.131237 , "radius": $size[11], "fillKey": "$col[11]", "project": "BRCA-EU"},
]);
close $file;

use POSIX qw(strftime);

my $date = strftime "%m/%d/%Y - %R", localtime;

#updates the average data for the chart
#appending to file with all average data
open(my $f, '>>', "~/gitroot/pancancer-info/pancan-scripts/map-data/ave_data_archive.csv") or die ("Could not open ave_data_archive.csv");
print $f "$date,";
my $k = 0;
my $count1 = 0;
for ($k = 0; $k < scalar @totals - 9; $k++){
        if ($count1 >= 0 && $count1 < scalar @totals -10){printf $f "%.2f,", $ave[$k];}
        else {printf $f "%.2f\n", $ave[$k];}
        $count1 += 1;
}
close $f;

#updates the total uploads for the chart
#appending to file with all upload data
open(my $f1, '>>', "~/gitroot/pancancer-info/pancan-scripts/map-data/up_data_archive.csv") or die ("Could not open up_data_archive.csv");
print $f1 "$date,";
my $r = 0;
my $count2 = 0;
for ($r = 0; $r < scalar @totals - 9; $r++){
        if ($count2 >= 0 && $count2 < scalar @totals -10){printf $f1 "%.2f,", $uploads[$r];}
        else {printf $f1 "%.2f\n", $uploads[$r];}
        $count2 += 1;
}
close $f1;

my @ary = [];
my $count_ave = 0;
my @ary1 = [];
my $count_up = 0;
my @day_ary1 = [];
my $count_day1 = 0;
my @day_ary2 = [];
my $count_day2 = 0;

#finding number of rows in the archived data
open(FH,"~/gitroot/pancancer-info/pancan-scripts/map-data/ave_data_archive.csv") or die("Can't open ave_data_archive.csv");
while (my $line = <FH>) {
    $count_ave += 1;
    push (@ary,"$line");
    my $result = index($line,'12:0');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary1,$line);
           $count_day1 ++;}
    elsif($result1 != -1){push (@day_ary1,$line);}
}
close(FH);

#only displaying 20 lines on the chart for hourly
open(my $file_ave, '>',"~/gitroot/pancancer-info/pancan-scripts/map-data/ave_data.csv") or die("Can't open ave_data.csv");
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

#only displaying 20 lines for daily
open(my $file_ave2, '>',"~/gitroot/pancancer-info/pancan-scripts/map-data/ave_daily.csv") or die("Can't open ave_daily.csv");
if ($count_day1 > 20){
        my $h = 0;
        print $file_ave2 $day_ary1[1];
        for ($h = $count_day1 -19; $h < $count_day1 +2;$h++){
                my $result = index($day_ary1[$h],'12:0');
                if ($result != -1){
                print $file_ave2 $day_ary1[$h];
        }
}
}
else {
        print $file_ave2 $day_ary1[1];
        my $p = 0;
        for ($p = 0; $p < $count_day1 +2;$p++){
                my $result = index($day_ary1[$p],'12:0');
                if ($result != -1){
                print $file_ave2 $day_ary1[$p];
        }}
};
close $file_ave2;

#finding number of rows in the archived data
open(FH,"~/gitroot/pancancer-info/pancan-scripts/map-data/up_data_archive.csv") or die("Can't open up_data_archive.csv");
while (my $line = <FH>) {
    $count_up += 1;
    push (@ary1,"$line");
    my $result = index($line,'12:0');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary2,$line);
           $count_day2 ++;}
    elsif($result1 != -1){push (@day_ary2,$line);}
}
close(FH);

#only displaying 20 lines on the chart for hourly 
open(my $file_up, '>',"~/gitroot/pancancer-info/pancan-scripts/map-data/up_data.csv") or die("Can't open up_data.csv");
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

#only displaying 20 lines for daily
open(my $file_up2, '>',"~/gitroot/pancancer-info/pancan-scripts/map-data/up_daily.csv") or die("Can't open ave_daily.csv");
if ($count_day2 > 21){
        my $h = 0;
        print $file_up2 $day_ary2[1];
        for ($h = $count_day2 -19; $h < $count_day2 +2;$h++){
                my $result = index($day_ary2[$h],'12:0');
                if ($result != -1){
                print $file_up2 $day_ary2[$h];
        }
}
}
else {
        print $file_up2 $day_ary2[1];
        my $p = 0;
        for ($p = 0; $p < $count_day2 +2;$p++){
                my $result = index($day_ary2[$p],'12:0');
                if ($result != -1){
                print $file_up2 $day_ary2[$p];
        }}
};
close $file_up2;

#writing to the data needed for the line graphs
foreach my $thing ('DKFZ','EBI','BSC','RIKEN','OSDC','ETRI'){
        open(my $file, '>>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${thing}_up_archive.csv") or die ("Can't open ${thing}_up_archive.csv") ;
        open(my $filea, '>>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${thing}_ave_archive.csv") or die ("Can't open ${thing}_ave_archive.csv");
        if ($thing eq 'DKFZ'){
                #print $file "quarter,PBCA-DE,MALY-DE,EOPC-DE\n";
                #print $filea "quarter,PBCA-DE,MALY-DE,EOPC-DE\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date,$uploads[8],$uploads[9],$uploads[10]";
                print $filea "$date,$ave[8],$ave[9],$ave[10]";}
        elsif ($thing eq 'EBI'){
                #print $file "quarter,BRCA-UK,CMDI-UK,BOCA-UK,PRAD-UK,ESAD-UK,BRCA-EU,PACA-CA\n";
                #print $filea "quarter,BRCA-UK,CMDI-UK,BOCA-UK,PRAD-UK,ESAD-UK,BRCA-EU,PACA-CA\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date,$uploads[14],$uploads[15],$uploads[16],$uploads[12],$uploads[13],$uploads[11],$uploads[2]";
                print $filea "$date,$ave[14],$ave[15],$ave[16],$ave[12],$ave[13],$ave[11],$ave[2]";}
        elsif ($thing eq 'BSC'){
                #print $file "quarter,CLLE-ES\n";
                #print $filea "quarter,CLLE-ES\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date,$uploads[3]";
                print $filea "$date,$ave[3]";}
        elsif ($thing eq 'RIKEN'){
                #print $file "quarter,BTCA-SG,LIRI-JP\n";
                #print $filea "quarter,BTCA-SG,LIRI-JP\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date,$uploads[4],$uploads[5]";
                print $filea "$date,$ave[4],$ave[5]";}
        elsif ($thing eq 'OSDC'){
                #print $file "quarter\n";
                #print $filea "quarter\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date";
                print $filea "$date";}
        elsif ($thing eq 'ETRI'){
                #print $file "quarter,LAML-KR\n";
                #print $filea "quarter,LAML-KR\n";
                print $file "\n";
                print $filea "\n";
                print $file "$date,$uploads[7]";
                print $filea "$date,$ave[7]";}
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

#finding number of rows in the archived data
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${elems}_ave_archive.csv") or die ("Can't open ${elems}_ave_archive.csv");
while (my $line = <FH>) {
    $count_avere += 1;
    push (@aryre,"$line");
    my $result = index($line,'12:0');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary1re,$line);
           $count_day1re ++;}
    elsif($result1 != -1){push (@day_ary1,$line);}
}
close(FH);

#only displaying 20 lines on the chart for hourly
open(my $file_ave, '>',"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${elems}_ave_data.csv") or die ("Can't open ${elems}_ave_data.csv");
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

open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${elems}_up_archive.csv") or die ("Can't open ${elems}_up_archive.csv");
while (my $line = <FH>) {
    $count_upre += 1;
    push (@ary1re,"$line");
    my $result = index($line,'12:0');
    my $result1 = index($line,'quarter');
    if ($result != -1){
           push (@day_ary2re,$line);
           $count_day2re ++;}
    elsif($result1 != -1){push (@day_ary2re,$line);}
}
close(FH);
#only displaying 20 lines on the chart for hourly 
open(my $file_up, '>',"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${elems}_up_data.csv") or die ("Can't open ${elems}_up_data.csv");
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
