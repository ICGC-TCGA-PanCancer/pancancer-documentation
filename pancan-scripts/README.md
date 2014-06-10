# PANCAN.INFO

## About
The files in this directory are all the ones being used on pancan.info . Everything needed is contained here except for the script workflow_decider.pl which is in:
    
    https://github.com/SeqWare/public-workflows/tree/feature/brian_workflow_2.5/decider-bwa-pancancer



## Sample Usage
Preview of how workflow_decider.pl is used.
Run the program without arguments to see the latest options. For example:

    $ perl decider-bwa-pancancer/workflow_decider.pl
    USAGE: 'perl decider-bwa-pancancer/workflow_decider.pl --gnos-url <URL> --cluster-json <cluster.json> [--working-dir <working_dir>] [--sample <sample_id>] [--threads <num_threads_bwa_default_8>] [--test] [--ignore-lane-count] [--force-run] [--skip-meta-download] [--report <workflow_decider_report.txt>] [--settings <seqware_settings_file>] [--upload-results]'
    	--gnos-url           a URL for a GNOS server, e.g. https://gtrepo-ebi.annailabs.com
    	--cluster-json       a json file that describes the clusters available to schedule workflows to
    	--working-dir        a place for temporary ini and settings files
    	--sample             to only run a particular sample
    	--threads            number of threads to use for BWA
    	--test               a flag that indicates no workflow should be scheudle, just summary of what would have been run
    	--ignore-lane-count  skip the check that the GNOS XML contains a count of lanes for this sample and the bams count matches
    	--force-run          schedule workflows even if they were previously run/failed/scheduled
    	--skip-meta-download use the previously downloaded XML from GNOS, only useful for testing
    	--report             the report file name
    	--settings           the template seqware settings file
    	--upload-results     a flag indicating the resulting BAM files and metadata should be uploaded to GNOS, default is to not upload!!!
