#!/bin/bash
rm all.csv
cp temp.csv all.csv
#cp temp2.csv all2.csv

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-bsc/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo bsc --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo bsc --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done bsc"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-dkfz/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo dkfz --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo dkfz --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done dkfz"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-ebi/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo ebi --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo ebi --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done ebi"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-etri/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo etri --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo etri --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done etri"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-riken/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo riken --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo riken --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done riken"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/gtrepo-cghub/xml/
rm out.csv
cp ../../temp.csv out.csv
#cp ../../temp2.csv out2.csv
for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse.pl --repo cghub --file $i >> out.csv ; done
#for i in $(\grep -l qc_metrics `grep -L submitter_aliquot_id *`); do  perl ../../xml_parse2.pl --repo cghub --file $i >> out2.csv ; done
tail -n +2 out.csv >> ../../all.csv
#tail -n +2 out2.csv >> ../../all2.csv
echo "done cghub"

cd /home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/
rm all_qc.csv
cp temp.csv all_qc.csv
perl cleanup.pl >> all_qc.csv
echo "done cleanup"
perl specimen_bases.pl > bases.csv

cp all_qc.csv all_qc.txt
cp all_qc.csv /var/www/qc_read.csv
cp all_qc.txt /var/www/qc_read.txt
cp bases.csv /var/www/qc_files/qc_spec.csv
cp bases.csv /var/www/qc_spec.txt
echo DONE
