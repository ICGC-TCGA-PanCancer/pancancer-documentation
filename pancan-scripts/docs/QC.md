# QC Metrics (http://pancancer.info/qc)

## About 
This page shows the qc metrics for that are from the xml files created from the workflow_decider.pl . Only the aligned files have qc metrics so not all xml files are included. It provides a histogram showing distribution of whatever metric you would like to look at. You can also filter the results by readgroup or specimen, by project, and by specimen type. This shows the user a good indication of the quality of the files uploaded. There are also links provided to show the data that has been graphed so the user can analyze it themselves.

## Collecting the Data
As described in the brief description, all the data is from the xml files created from the workflow_decider.pl . The script xml_parse.pl is able to take a file and produce this output:

    2014-07-31 15:33:09,105a51c4-cc7e-4d0f-9cf8-e4d64a31d14d,UCEC-US,Primary tumour - solid tissue,5c22c8d6-5805-455c-8e1c-e6b8006738e4,105a51c4-cc7e-4d0f-9cf8-e4d64a31d14d,ca213835-efc5-4216-a762-a6b320b516bf,,b8f26252-d5bc-4084-8006-dc2ef9928a52,648456b0-d91a-11e3-950a-0927963883d2,184798760,100,7454081758,WUGSC:C2U7DACXX_2,20477109,36777574305,246.807,WGS:WUGSC:H_LR-D1-A17K-01A-11D-A325-09-lg1-lib1a,184671356,157733691,180063318,82923635,100,18463176094,1cfaec8e-9f51-42c0-8543-f055e6492c12,ILLUMINA,648456b0-d91a-11e3-950a-0927963883d2,74810056,18314398211,369597520,7474360756,251.000,31.518,PAWG.1cfaec8e-9f51-42c0-8543-f055e6492c12.bam,184798760,184227162,368898518,36959752000,12.3199173333333,99.5070916736671,99.8108748132293,0.426771508098864,48.7187570955563,5.54038051986929
