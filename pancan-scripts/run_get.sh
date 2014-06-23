#!/bin/bash

cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/results
rm *.txt
perl `locate get_spreadsheets.pl`
perl `find /home/ubuntu/gitroot/ -name get_uploads.pl`
cat *.txt > all_sheets.txt
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
cat *-ES*.txt > esfiles.txt
cat *-SG*.txt > sgfiles.txt
cat *-JP*.txt > jpfiles.txt
cat *LIRI-JP*.txt > lirijpfiles.txt
cat *BRCA-UK*.txt > brcaukfiles.txt
cat *BRCA-EU*.txt > brcaeufiles.txt
cat *PRAD-UK*.txt > pradukfiles.txt
cat *-KR*.txt > krfiles.txt
cat *ESAD-UK*.txt > camfiles.txt
cat *BRCA-EU*.txt >> camfiles.txt
cat *PRAD-UK*.txt > hinfiles.txt
cat *BRCA-UK*.txt >> hinfiles.txt
cat *BOCA-UK*.txt >> hinfiles.txt
cat *CMDI-UK*.txt >> hinfiles.txt
cat Pancan-UP*.txt > summary.txt
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data
perl `locate update_data.pl`
perl `locate generate_upload_info.pl` > out.csv
perl `locate arc_read.pl`
perl `locate bubble_read.pl`
sudo cp *.json /var/www/
sudo cp *.csv /var/www/
cd /var/www/
sudo mv *bub*.json bubbles/
sudo mv *up*.csv up_data/
sudo mv *ave*.csv ave_data/
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts/results
sudo cp *files.txt /var/www/
cd /home/ubuntu/gitroot/pancancer-info/pancan-scripts
