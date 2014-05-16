# TCGA/ICGC PanCancer - Workflow Development Node Launch SOP

This is our SOP for how to create a SeqWare workflow development environment
for use with the PanCancer project. Since the environment also contains
GridEngine and Hadoop it may be useful for creating workflows using those tools
directly however the focus will be on SeqWare workflow development. In this SOP we use
[VirtualBox](https://www.virtualbox.org/) to run a local VM from a snapshot OVA
file we provide.  Like the AMI tutorial, this tutorial makes use of a pre-provsioned
image so it is fast to setup and requires no lengthy configuration.

## Use Cases

This approach is designed to create a workflow
development environment for creating and testing new workflows locally in
VirtualBox. It does not require any packages to be installed or setup at runtime, all software
is pre-configured and ready to go in the VM which makes the whole process very fast.
The downside is this is a single-node cluster so it is not appropriate for real
analysis for whole genomes or scaling up your testing.

## Steps

* you will be working locally using VirtualBox, make sure you have a Linux or Mac available to work on with 16G of RAM
* download and install:
    * VirtualBox
    * our OVA export of the VirtualBox VM
* import the OVA into VirtualBox
* develop, test, run workflows based on the other guides we provide

## Detailed Steps Using VirtualBox Locally

The following is a detailed example showing you how to setup the workflow development environment:

### Step - Download and Install VirtualBox & the OVA

These steps will be different depending on whether or not you use a Mac or
Linux host machine.  Much more information about VirtualBox can be found
at their site, see http://virtualbox.org.

This is an example for a Linux machine running Ubuntu 12.04. You will need to
follow a similar process if using a Mac but the detail are beyond the scope of
this document.

Note the "$" is the Bash shell prompt in these examples and "#" is a comment:

    # download and install VirtualBox
    $ wget http://download.virtualbox.org/virtualbox/4.3.8/virtualbox-4.3_4.3.8-92456~Ubuntu~precise_amd64.deb
    # sudo dpkg -i virtualbox-4.3_4.3.8-92456~Ubuntu~precise_amd64.deb

    # download the SeqWare OVA
    # make sure you check http://seqware.io for the latest OVA
    $ wget <FILLMEIN>

You then use the "Import Appliance..." function from within the VirtualBox GUI
to import the OVA.  Make sure the default settings are reasonable; you want 64-bit Ubuntu,
16G of RAM (minimum 12G for the BWA workflow, others may require more), 2 or more CPUs,
and do not reinitialize the MAC address.
When complete, launch the virtual machine in the GUI.

## Next Steps

For workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into
problems.  If you are new to SeqWare I would recommend you follow our three
Getting Started Guides:

* User Guide
* Developer Guide
* Admin Guide

The OVA virtual machine is designed to work hand-in-hand with these guides.

You can also pick up with our subsequent guides, such as [Test Run the Production BWA Workflow](run_bwa.md), since this VM should be ready to go for use with these.
