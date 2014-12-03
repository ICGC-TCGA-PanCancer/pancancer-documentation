#!/bin/bash

# need this line to run perlbrew
source ~/.bash_profile

cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/results
rm *.txt
cd ../
cp gacacnfiles.txt results
cd results

# getting all the updated spreadsheets
perl `find /home/ubuntu/gitroot/pancancer-info/ -name get_spreadsheets.pl`
#perl `find /home/ubuntu/gitroot/pancancer-info/ -name get_uploads.pl`

# making all the necessary files
cat *.txt > all_files.txt
cat *-DE*.txt > defiles.txt
cat *-AU*.txt > aufiles.txt
cat *PBCA-DE*.txt > pbcadefiles.txt
cat *MALY-DE*.txt > malydefiles.txt
cat *EOPC-DE*.txt > eopcdefiles.txt
cat *ESAD-UK*.txt > esadukfiles.txt
cat *BOCA-UK*.txt > bocaukfiles.txt
cat *CMDI-UK*.txt > cmdiukfiles.txt
cat *-CA*.txt > cafiles.txt
cat *PACA-CA*.txt > pacacafiles.txt
tail -n +2 *PACA-CA2*.txt >> pacacafiles.txt
cat *-ES*.txt > esfiles.txt
cat *-SG*.txt > sgfiles.txt
cat *-JP*.txt > jpfiles.txt
cat *LIRI-JP*.txt > lirijpfiles.txt
cat *BRCA-UK*.txt > brcaukfiles.txt
cat *BRCA-EU*.txt > brcaeufiles.txt
cat *PRAD-UK*.txt > pradukfiles.txt
cat *-KR*.txt > krfiles.txt
cat *ORCA-IN*.txt > orcainfiles.txt
cat *ESAD-UK*.txt > camfiles.txt
cat *BRCA-EU*.txt >> camfiles.txt
cat *PRAD-UK*.txt > hinfiles.txt
cat *BRCA-UK*.txt >> hinfiles.txt
cat *BOCA-UK*.txt >> hinfiles.txt
cat *CMDI-UK*.txt >> hinfiles.txt
cat *PACA-AU*.txt > pacaaufiles.txt
cat *PAEN-AU*.txt > paenaufiles.txt
cat *OV-AU*.txt > ovaufiles.txt
cat Pancan-UP*.txt > summary.txt
perl ../cleanup_esad.pl

# creating all the files needed for the site
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data
perl `find /home/ubuntu/gitroot/pancancer-info -name update_data.pl`
perl `find /home/ubuntu/gitroot/pancancer-info -name generate_upload_info.pl` > out.csv
perl `find /home/ubuntu/gitroot/pancancer-info -name arc_read.pl`
perl `find /home/ubuntu/gitroot/pancancer-info -name bubble_read.pl`

# copying everything over to the right directory 
cp *.json /var/www/
cp *.csv /var/www/
cd /var/www/
mv *bub*.json bubbles/
mv *up*.csv up_data/
mv *ave*.csv ave_data/
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/results
cp *files.txt /var/www/
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts
