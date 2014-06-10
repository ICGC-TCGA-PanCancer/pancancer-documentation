#!/bin/bash

Current_date=$(date +"%Y_%m_%d")
cd ~/git/public-workflows/decider-bwa-pancancer/results
mv all_sheets.txt all_sheets_"$Current_date".txt
mv defiles.txt defiles_"$Current_date".txt
mv esadukfiles.txt esadukfiles_"$Current_date".txt
mv cafiles.txt cafiles_"$Current_date".txt
mv esfiles.txt esfiles_"$Current_date".txt
mv sgfiles.txt sgfiles_"$Current_date".txt
mv jpfiles.txt jpfiles_"$Current_date".txt
mv brcaukfiles.txt brcaukfiles_"$Current_date".txt
mv *.txt ../old_results
perl `find ~/git -name get_spreadsheets.pl`
cat *.txt > all_sheets.txt
cat *-DE*.txt > defiles.txt
cat *ESAD-UK*.txt > esadukfiles.txt
cat *-CA*.txt > cafiles.txt
cat *-ES*.txt > esfiles.txt
cat *-SG*.txt > sgfiles.txt
cat *-JP*.txt > jpfiles.txt
cat *BRCA-UK*.txt > brcaukfiles.txt
cd /usr/lib/cgi-bin
./update_data
cd /home/jlugo/Documents/perl-stuff/
perl generate_upload_info.pl > out.csv
perl arc_read.pl
perl bubble_read.pl
cd ~/git/public-workflows/decider-bwa-pancancer/results
