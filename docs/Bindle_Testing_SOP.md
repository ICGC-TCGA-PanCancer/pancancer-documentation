# Bindle Testing SOP

## Overview

This guide will guide you through the basic testing process for bindle.
Note that this guide does not explain you how to set up bindle for the 
particular environment you are going to be testing. For that, please 
refer to CloudBindle/Bindle repository.

## Testing Process

The following is a detailed example of the testing process once you have launched
a cluster successfully using bindle. 

### Step - Run the Seqware Sanity Check Tool

This simply checks if the seqware environment is set up correctly on the cluster.

    # switch to the seqware user
    $ sudo su - seqware
    # get the jar for seqware sanity check if you do not have it already
    $ wget https://seqwaremaven.oicr.on.ca/artifactory/seqware-release/com/github/seqware/seqware-sanity-check/1.0.15/seqware-sanity-check-1.0.15-jar-with-dependencies.jar
    # run the jar file   
    $ java -jar seqware-sanity-check-1.0.15-jar-with-dependencies.jar
    # Check to see if it passed (0 is a pass and fail otherwise)
    $ echo $?

### Step - Run the HelloWorld Workflow

This step assumes that the workflow is installed already on the cluster.  If not, you can download a copy of the workflow and install it yourself following our guides on http://seqware.io (see https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13.zip). 

    # assumes you have logged into your master node and switched to the seqware user
    $ ls provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13
    # now run the workflow
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13 

### Step - Run the BWA Workflow in local test mode if you have installed bindle using the BWA template

    # assumes you have logged into your master node and switched to the seqware user
    $ ls provisioned-bundles/Workflow_Bundle_BWA_2.5.0_SeqWare_1.0.13
    # now run the workflow
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_BWA_2.5.0_SeqWare_1.0.13/

## Next Steps

Update the [testing matrix](https://github.com/SeqWare/pancancer-info/blob/develop/docs/README.md#testing-matrix)
