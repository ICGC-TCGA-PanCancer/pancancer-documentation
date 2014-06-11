#!/bin/bash

cd ~/gitroot/pancancer-info/pancan-scripts/results
rm *.txt
perl `find ~/gitroot -name get_spreadsheets.pl`
cat *.txt > all_files.txt
cat *-DE*.txt > defiles.txt
cat *ESAD-UK*.txt > esadukfiles.txt
cat *-CA*.txt > cafiles.txt
cat *-ES*.txt > esfiles.txt
cat *-SG*.txt > sgfiles.txt
cat *-JP*.txt > jpfiles.txt
cat *BRCA-UK*.txt > brcaukfiles.txt
cd ~/gitroot/pancancer-info/pancan-scripts/map-data
perl `find ~/gitroot -name update_data.pl`
perl `find ~/gitroot -name generate_upload_info.pl` > out.csv
perl `find ~/gitroot -name arc_read.pl`
perl `find ~/gitroot -name bubble_read.pl`
cd ~/gitroot/pancancer-info/pancan-scripts
