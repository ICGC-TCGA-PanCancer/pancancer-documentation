use Time::ParseDate;
use Time::CTime;
use Time::Piece;
use String::Util 'trim';
use Getopt::Long;
use POSIX qw(strftime);
use Date::Calc qw/Delta_Days/;
use POSIX;
use Data::Dumper;
use DateTime::Format::Strptime;
use List::Util qw( min max );
use JSON qw( decode_json );

my $spot;
my $metric;
my %id;
my $riken;
my $dkfz;
my $osdc_icgc;
my $ebi;
my $etri;
my $cghub;
my $count=0;

if (scalar(@ARGV) < 2) {
die qq(USAGE: perl align_count.pl --spot <GNOS REPO> --metric <METRIC>); }
GetOptions ("spot=s" => \$spot, "metric=s" => \$metric);

my $filename = 'transfer_timing.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my @ary;
my @repos;
my @metrics;
my @list;

my $json = JSON->new;
my $data = $json->decode($json_text);
if($metric eq "all"){
foreach my $spot (keys $data){
	foreach my $date (keys $data->{"$spot"}){ 
	my $dt = Time::Piece->strptime($date,"%Y%m%d.%T");	
	my $new_dt = $dt->strftime("%Y/%m/%d %T");
		foreach my $repo (keys $data->{"$spot"}->{"$date"}){
			foreach my $metric (keys $data->{"$spot"}->{"$date"}->{"$repo"}){
			my $met = $data->{"$spot"}->{"$date"}->{"$repo"}->{"$metric"};
			print "spot: $spot date: $new_dt repo: $repo $metric: $met\n";
			}
		}
	}
}
	}

	else{
	print "quarter,gtrepo-etri,cghub.ucsc,gtrepo-riken,gtrepo-dkfz,gtrepo-ebi,gtrepo-osdc-icgc\n";
	foreach my $date (keys $data->{"$spot"}){
		my $dt = Time::Piece->strptime($date,"%Y%m%d.%T");
		my $new_dt = $dt->strftime("%Y/%m/%d %T");
		my $non_time = $dt->strftime("%Y%m%d");
		$id{$non_time} += 1;
		if ($id{$non_time} == 1){
		#print "$new_dt,";
		$count = 0;
			foreach my $repo (keys $data->{"$spot"}->{"$date"}){
				$count += 1;
				my $met = $data->{"$spot"}->{"$date"}->{"$repo"}->{"$metric"};
				#print "spot: $spot date: $new_dt repo: $repo $metric: $met\n";
				if ($repo eq "gtrepo-etri.annailabs.com"){$etri = $met;}#print $etri;}
				elsif ($repo eq "gtrepo-dkfz.annailabs.com"){$dkfz = $met;}#print $dkfz;}
				elsif ($repo eq "gtrepo-riken.annailabs.com"){$riken = $met;}#print $riken}
				elsif ($repo eq "gtrepo-osdc-icgc.annailabs.com"){$osdc_icgc = $met;}#print $osdc_icgc;}
				elsif ($repo eq "gtrepo-ebi.annailabs.com"){$ebi = $met;}#print $ebi;}
				elsif ($repo eq "cghub.ucsc.edu"){$cghub = $met;}#print $cghub;}
			}
		#if($etri eq ""){$etri=0;}
		#print "$etri,$cghub,$riken,$dkfz,$ebi,$osdc_icgc\n";
		push(@list, [$non_time,$new_dt,$etri,$cghub,$riken,$dkfz,$ebi,$osdc_icgc]);
		}
	#print "$etri,$cghub,$riken,$dkfz,$ebi,$osdc_icgc\n";
}
my @sorted = sort {$a->[0] <=> $b->[0]} @list;
my $len = scalar(@sorted);
#if ($len >= 14){
my $y=0;
my $t=0;
for ($y=$len-14;$y < scalar(@sorted);$y++){
	for ($t=1;$t < 8;$t++){
		if ($t < 7){
		print "$sorted[$y][$t],";
		}
		else{
		print "$sorted[$y][$t]\n";
		}
	}
}
#}
#}
}
#print @metrics[1];
#print Dumper @metrics;
#print Dumper $data->{'virginia'}->{"@ary[1]"};
#print "\n";


