
use strict;
use warnings;

use WWW::Mechanize;
# Create a new mechanize object
my $mech = WWW::Mechanize->new();
my @id = [];
my $count1;
my $count2;

foreach my $a ("defiles.txt","brcaukfiles.txt","esadukfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt"){
  $count1 = 0;
  $count2 = 0;
 foreach my $i ("gtrepo-bsc", "gtrepo-dkfz", "gtrepo-osdc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {
   $count2 ++;
   @id = [];
  my $url = "http://pancancer.info/${i}.log";
  # Associate the mechanize object with a URL
  $mech->get($url);
  # Print the content of the URL
  # gets the content of the webpage which is the GNOS repo
  my @content = [];
  open(my $fh, '>', "/home/jlugo/Documents/Pancan-files/${i}.log"); 
  print $fh $mech->content;
  close $fh;
  my @line;

  # Load URL::Escape to escape URI's with uri_escape method.
  use URI::Escape;
  my @links = $mech->links;
  foreach my $link (@links) {
      print uri_escape($link->url), "\n";   
  }

  # creates log files for the GNOS repos to read from later
  open(FH,"/home/jlugo/Documents/Pancan-files/${i}.log") or &dienice("Can't open guestbook.txt: $!");
  while (my $line = <FH>) {
   my $result = index($line, "SPECIMEN/SAMPLE:");
   if ($result == 1){
    push(@id, substr($line,$result+17));
  }
  }
  close(FH);

  my ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual);

  my $uploaded = 0;
  my $total_files = 0;

  # checking if specimen_id is in any GNOS repo log file
  open (FILE, "/home/jlugo/git/public-workflows/decider-bwa-pancancer/results/${a}");
  while (<FILE>) {
  chomp;
  ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
  if (grep( /^$submitter_specimen_id$/, @id) && $submitter_specimen_id ne '' ){
    $uploaded += 1;
   }
   if ($Study ne "Study"){
    $total_files += 1;}
  }
  close (FILE);
  
  # creates output according to where it is uploaded and how much has been uploaded
  if ($uploaded > 0){
   print "$a,";
   print "${i},";
   print "uploaded: $uploaded,";
   print "total files: $total_files\n";
   $count1 ++;
   }
   elsif ($count1 == 0 && $count2 == 6){
   print "$a,";
   print "None,";
   print "uploaded: 0,";
   print "total files: $total_files\n";}
  }
}