use Time::ParseDate;
use Time::CTime;
use Time::Piece;
use Date::Calc qw/Delta_Days/;
use POSIX;
use Data::Dumper;
use List::Util qw( min max );
use JSON qw( decode_json );

my @days;
my @count;
my @thing;
my %hsh;
my @dates;
my @final;
my $filename = 'train2.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my @data = $json->decode($json_text);
my $add;#=$data[0][1]{"repo"};

#print scalar $data[0];
for (my $i=0;$i < 8;$i++){
        $add += $data[0][$i]{"align"};
}

#print $add;

open(FH,"align_archive.csv") or die("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
  chomp $line;
  @fields = split "," , $line;
  if(index($line,"12:") != -1){
        push(@days,$fields[0]);
        push(@count,$fields[1]);}
}
close FH;
my $day = 0;
my $two = 0;
my $week = 0;

if (scalar @days >= 7){
        @days = @days[-7,-1];
        $day = $count[-1] - $count[-2];
        push(@thing,$day);
        $two = ($count[-1] - $count[-3])/2;
        push(@thing,$two);
        $week = ($count[-1] - $count[-7])/7;
        push(@thing,$week);
}

elsif(scalar @days < 7){
  $day = $count[-1] - $count[-2];
  push(@thing,$day);
  $two = ($count[-1] - $count[-3])/2;
  push(@thing,$two);
  $week = 0;
  push(@thing,$week);
}
my $min = min @thing;
my @real;

if ($min == 0 ){
for (my $m=0; $m < scalar @thing;$m++){
        if ($thing[$m] != 0){
                push(@real, $thing[$m]);
        }
}}
$min = min @real;
my $total = 4150;
my $current = $add;
my $diff = ($total - $current);
my $days = ceil($diff/$min);

my $date = strftime "%B %d %Y %R", localtime;

my $format = "%B %d %Y %R";
my $time = parsedate($date);
my $check1=0;
my $check2=0;
my $check3=0;
my %shh = ("day"=> {"est"=>"N/A",
                    "date"=>"N/A",},
        "two"=>{"est"=>"N/A",
                    "date"=>"N/A",},
        "week"=>{"est"=>"N/A",
                    "date"=>"N/A",});

print "quarter,24 Hours,48 Hours,Week\n";
print "$date,$current,$current,$current\n";
# add $numdays worth of seconds
for (my $t=1; $t < $days+1;$t++){
        my $newval = $day*$t + $current;

        my $newval1 = $two*$t + $current;

        my $newval2 = $week*$t + $current;

        my $newtime = $time + ($t * 24 * 60 * 60);
        my $newdate = strftime("%B %d %Y %R",localtime($newtime));
        if ($newval1 >= 4150){
                $check1+=1;
                if($check1 == 1){
                $shh{"two"}{"est"} = $newdate;
                $shh{"two"}{"date"} = $date;}}
        elsif ($newval >= 4150){
                $check2+=1;
                if($check2==1){
                $shh{"day"}{"est"} = $newdate;
                $shh{"day"}{"date"} = $date;}}
        elsif ($newval2 >= 4150){
                $check3+=1;
                if($check3==1){
                $shh{"week"}{"est"} = $newdate;
                $shh{"week"}{"date"} = $date;}}
        push (@dates,"$newdate,$newval,$newval1,$newval2\n");
}

for (my $u = 0;$u < scalar @dates;$u+=7){
        print $dates[$u];
}

open(my $file,'>>', "dates_archive.csv");
for my $keys (keys %shh){
        for my $item (keys $shh{$keys}){
                print $file "$keys,$item,$shh{$keys}{$item}\n";
        }
}
close $file;


#print Dumper(\%shh);
