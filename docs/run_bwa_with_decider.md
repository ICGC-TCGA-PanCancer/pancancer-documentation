# TCGA/ICGC PanCancer - BWA-Mem Automated Workflow Running SOP

## Overview

This document describes how to automate the running of the BWA-Mem SeqWare
workflow for TCGA/ICGC PanCancer. In order to do this you need to have a GNOS
repository to read data and metadata from, one or more SeqWare node/cluster
provisioned with Bindle (CloudBindle) on a PanCancer cloud, and the BWA-Mem workflow
installed on those SeqWare nodes/clusters. The general idea is you run the
"decider" documented here on an hourly cron job on your launcher host which
then finds unaligned samples and assigns running of these samples on one of the
SeqWare hosts.

## Requirements

* seqware nodes/clusters, see https://github.com/CloudBindle/Bindle, specifically https://github.com/SeqWare/pancancer-info/blob/develop/docs/workflow_dev_node_with_bindle.md for information about building nodes/clusters for PanCancer
* a cluster.json that describes the clusters (see the sample cluster.json)
* a decider VM to run the decider 

* BWA workflow installed on each node/cluster, see https://github.com/SeqWare/pancancer-info/blob/develop/docs/run_bwa.md
* GNOS key installed on each node/cluster, get your key from https://pancancer-token.annailabs.com/ and replace the contents of gnostest.pem
* GNOS repository filled with data that meets our metadata requirements, see https://wiki.oicr.on.ca/display/PANCANCER/PAWG+Researcher%27s+Guide

## Architecture

This automated guide assumes you will use the following architecture:

                      GNOS repo
                          ^
                          |       -> cluster1 -> run workflow BWA-Mem on sample1
    launcher host -> decider cron -> cluster2 -> run workflow BWA-Mem on sample2
                                  -> cluster3 -> run workflow BWA-Mem on sample3

In this setup, several SeqWare clusters (or nodes) are created using
SeqWare-Vagrant and the template for PanCancer. The BWA-Mem SeqWare workflow is
installed on each cluster/node as part of this process. The launcher host
periodically runs the decider which queries GNOS to find samples that have yet
to be aligned. It then checks each SeqWare cluster/node it knows about to
determine that the alignment is not currently running (or previously failed).
If both criteria are met (not aligned yet, not running/failed) the decider
"schedules" that sample to a cluster/node for running the BWA workflow. The
final step in the worklfow is to upload the results back to GNOS, indicating to
future runs of the decider that this sample is now aligned.

## Getting the Decider and Dependencies

Download the repository:
    $ mkdir ~/git
    $ cd git
    $ git clone https://github.com/SeqWare/public-workflows.git
    $ cd public-workflows/decider-bwa-pancancer
    $ sudo bash install 


You can check to see if everything is correctly installed with:

    $ perl -c bin/workflow_decider.pl

That should produce no errors.

## Cluster Setup

You need to setup one or more nodes/clusters that are used for running
workflows and processing data.  These are distinct from the launcher host which
runs the decider documented here.  Launch one or more compute clusters using
the [TCGA/ICGC PanCancer - Computational Node/Cluster Launch
SOP](https://github.com/SeqWare/pancancer-info/blob/develop/docs/prod_cluster_with_bindle.md).

You should use the node/cluster profile that includes the installation of the
BWA-Mem workflow for PanCancer. This will ensure your compute clusters are
ready to go for analysis.  However, there is one extremely important step that
you will need to manually perform on each cluster you setup.  You need to
ensure you first get a GNOS key for the PanCancer project by following
instructures at the [PAWG Researcher
Guide](https://wiki.oicr.on.ca/display/PANCANCER/PAWG+Researcher%27s+Guide).
You then need to take the contents of this key and replace the contents of
"~seqware/provisioned-bundles/Workflow_Bundle_BWA_{workflow-version}._SeqWare_1.0.11/Workflow_Bundle_BWA/{workflow-version}/scripts/gnostest.pem"
on the master node of each computational cluster you launch. This will ensure
input and output data can be read/written to the GNOS repositories used in the
project.

## Cluster.JSON

This file provides a listing of the available clusters that can be used to
schedule workflows.  You typically setup several clusters/nodes on a given
cloud environment and then use them for many workflow runs over time.  Some
clusters may be retired or killed over time so it is up to the decider caller
to keep the cluster.json describing the clusters available up to date.  Here is
an example of the JSON format used for this file.  If you use the
SeqWare-Vagrant PanCancer profile that installs the BWA-Mem workflow you will
find it installed under SeqWare accession "2".

    {
      "cluster-name-1": {
         "workflow_accession": "2",
         "username": "admin@admin.com",
         "password": "admin",
         "webservice": "http://{cluster-ip}:8080/SeqWareWebService",
         "host": "master",
         "max_workflows": "1",
         "max_scheduled_workflows": "1"

       }
    }

As you build new nodes/clusters you will create a "cluster-name-2",
"cluster-name-3" and so on.  You will then replace "master" with the IP address
of the master node for each of you new clusters/nodes. Note that the "host"
parameter is what the host is called that the workflow is being scheduled on.
Given our provisioning process this is almost always "master". Do not use the
IP address here.

Assuming you are using the SeqWare-Vagrant process to build your computational
clusters, you can get the IP addresses of the master nodes under the
--working-dir specified when you launched the node/cluster.  Change directories
to that directory and then to master.  Then execute "vagrant ssh-config".  That
will show you the IP address of master.  For example, if your working directory
is "target-os-cluster-1":

    $ cd target-os-cluster-1/master
    $ vagrant ssh-config

And the result looks like:

    Host master
      HostName 10.0.20.184
      User ubuntu
      Port 22
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /home/ubuntu/.ssh/oicr-os-1.pem
      IdentitiesOnly yes
      LogLevel FATAL

You can then use this information to fill in your cluster.json config for the
decider.

## Getting to know the decider

    perl bin/workflow_decider.pl --man
    
    
This will provide you will an explaination of all the flags and how they are to be used. 

## Running the Decider in Testing Mode

First, you will want to run the decider in test mode just to see the samples
available in GNOS and their status (aligned or not). You do this on the
launcher host, presumably running in the same cloud as the GNOS instance you
point to (though not neccesarily). This will produce a report that clearly
shows what is available in GNOS, which samples have already been aligned, etc.

    Flags: --workflow-skip-scheduling --schedule-force-run

This will produce a report in "report.txt" for every sample in GNOS along with
sample workflow execution command lines.

## Running the Decider for Real Analysis

You typically want to run the decider to actually trigger analysis via a
workflow in one of two modes:

* running it manually for a given sample, perhaps to force alignment
* or via a cron job that will periodically cause the decider to run

### Manually Calling

You typically will manually call the decider for a single sample, for example,
if you want to force that sample to be re-run in order to test a workflow.
Here is an example of how to specify a particular sample:

    Flag: --schedule-sample[=][ ]<sample_uuid>  or  --schedule-center[=][]<center_name>

And this will just prepare to launch the workflow for sample sample_uuid

### Automatically Calling via Cron

Add the following to your cronjob, running every hour:

    perl bin/workflow_decider.pl --seqware-clusters cluster.json --workflow-version 2.6.0 

### Parameters

REQUIRED ARGUMENTS
    --seqware-clusters[=][ ]<cluster_json>
        JSON file that describes the clusters available to schedule workflows
        to. Should be located in the config folder.

    --workflow-version[=][ ]<workflow_version>
        Specify the BWA workflow version you would like to run (eg. 2.6.0)

OPTIONS
    --gnos-url[=][ ]<gnos_url>
        URL for a GNOS server, e.g. https://gtrepo-ebi.annailas.com

    --working-dir[=][ ]<working_directory>
        A place for temporary ini and settings files

    --use-cached-analysis
        Use the previously downloaded list of files from GNOS that are marked
        in the live state (only useful for testing).

    --seqware-settings[=][ ]<seqware_settings>
        The template seqware settings file

    --report[=][ ]<report_file>
        The report file name that the results will be placed in by the decider

    --use-live-cached
        A flag indicating that previously download xml files for each analysis
        file should not be downloaded again

    --schedule-ignore-failed
        A flag indicating that previously failed runs for this specimen should
        be ignored and the specimen scheduled again

    --schedule-sample[=][ ]<sample_uuid>
        For only running one particular sample based on its uuid

    --schedule-center[=][]<center_name>
        For only running samples from one institute

    --schedule-ignore-lane-count
        Skip the check that the GNOS XML contains a count of lanes for this
        sample and the bams count matches

    --schedule-force-run
        Schedule workflows even if they were previously completed

    --workflow-bwa-threads[=][ ]<thread_count>
        Number of threads to use for BWA

    --workflow-skip-scheduling
        Indicates no workflow should be scheduled, just summary of what would
        have been run.

    --workflow-upload-results
        A flag indicating the resulting BAM files and metadata should be
        uploaded to GNOS, default is to not upload!!!

    --workflow-skip-gtdownload
        A flag indicating that input files should be just the bam input paths
        and not from GNOS

    --workflow-skip-gtupload
        A flag indicating that upload should not take place but output files
        should be placed in output_prefix/output_dir

    --workflow-output-prefix[=][ ]<output_prefix>
        If --skip-gtupload is set, use this to specify the prefix of where
        output files are written

    --workflow-output-dir[=][ ]<output_directory>
        if --skip-gtupload is set, use this to specify the dir of where output
        files are written

    --workflow-input-prefix[=][ ]<prefix>
        if --skip-gtdownload is set, this is the input bam file prefix

## Dealing with Workflow Failure

Workflow failures can be monitored with the standard SeqWare tools, see
http://seqware.io for information on how to debug workflows.  If a failure
occurs you will need to use --force-run to run the workflow again.

## Dealing with Cluster Failures

Cluster failures can occur and the strategy for dealing with them is to replace
the lost cluster/node and modify the cluster.json.  Upon next execution, the
workflows will be scheduled to the new system.

## Monitoring the System

The system can be monitored with the standard SeqWare tools, see
http://seqware.io for more information.

## Cloud-Specific Notes

This section describes modifications needed on a per PanCancer cloud basis.

### BioNimbus PDC

This cloud uses a web proxy, the settings for which are stored in environment variables.  This means you need to override these variables when interacting with the local network.  For example, to run the decider on the launcher host you would do:

    http_proxy= perl bin/workflow_decider.pl --workflow-skip-schduling --schedule-ignore-lane-count --schedule-force-run --seqware-clusters cluster.json --report bionimbus.log --gnos-url https://gtrepo-osdc.annailabs.com

The "http_proxy=" here disables the proxy settings for just this command.

## TODO

* Add support for getting stats from GNOS, Make it so that a list of samples can be supplied for scheduling
