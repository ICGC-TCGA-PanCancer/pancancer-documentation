# TCGA/ICGC PanCancer - Workflow Development Node on Amazon

This is our SOP for how to create a SeqWare workflow development environment
for use with the PanCancer project. Since the environment also contains
GridEngine and Hadoop it may be useful for creating workflows using those tools
directly however the focus will be on SeqWare development. In this SOP we use
[Amazon Web Services](http://aws.amazon.com) to quickly spin up a single virtual
machine node for use as a workflow development or testing environment.

## Use Cases

The use case for launching an AWS instance is to quickly (<10 minutes) setup
an environment that can be used for workflow development, testing, and packaging.
It does not require any packages to be installed or setup at runtime, all software
is pre-configured and ready to go in the VM which makes the whole process very fast.
The downside is this is a single-node cluster so it is not appropriate for real
analysis for whole genomes or scaling up your testing.

## Steps

Rather than duplicate a ton of documentation that exists at AWS I will give you a
brief overview and direct you to that site for more details:

* sign up for AWS at http://aws.amazon.com, you will need a credit card
* locate the VM ID (AMI ID) you want to launch
* use the Amazon web console to launch this instance (or command line tools)
* log in over SSH as you would for any Amazon instance, you now have an environment ready to run or develop workflows in

## Detailed Steps

The following is a detailed example showing you how to setup the workflow development environment via this Amazon instance:

### Step - Obtain AWS Account

You need to signup on AWS's website, which requies a credit card.  Please take the time to read through the excellent documentation there on how to launch and access Linux machines in their cloud.

### Step - Find the Current AMI

Since we are building SeqWare workflows we will simply use the stock SeqWare AMI.  It is periodically updated, you can find the most recent AMI release on the SeqWare site: http://seqware.io

You can also find pre-release versions at https://seqware.github.io/unstable.seqware.io/docs/2-installation/
In particular, we are now testing newer versions of SeqWare deployed to AWS.

### Step - Launch the AMI

The details here are beyond the scope of this document since the AWS documents provide a much better explanation than I could.  A few tips, though.  First, we use AWS Virginia, if you use another location you will not be able to find the AMI.  Second, the AMI will automatically mount 1TB of workflow working directory space automatically. When you terminate your instance realize that everything is lost so be aware and keep your code checked in and valuable data uploaded to S3 or an equivalent destination.  You can read more about S3 on the AWS site.

## Next Steps

For workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into
problems.  If you are new to SeqWare I would recommend you follow our three
Getting Started Guides:

* User Guide
* Developer Guide
* Admin Guide

The AMI is designed to work hand-in-hand with these guides.

You can also pick up with our subsequent guides, such as [Test Run the Production BWA Workflow](run_bwa.md), since this VM should be ready to go for use with these.
