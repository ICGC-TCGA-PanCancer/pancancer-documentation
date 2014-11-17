# PanCancer Architecture

## DESCRIPTION

The architecture consists of two main parts: the GNOS servers that host all of the data and the clusters that process the data. 

### GNOS

There are several GNOS servers around the world which host the PanCancer data. They can be accessed with client tools such as "cgquery".

### Cloud Environments

The archtecture can be been created on a number of cloud (and non-cloud) environments such as VirtualBox, vCloud, OpenStack and AWS. 

#### Development

VirtualBox is supported to allow workflow developers the abililty to spin up a SeqWare on their own computer. 

#### Provisioning

[Architecture Provisioning Scripts](https://github.com/ICGC-TCGA-PanCancer/architecture-setup) have been created to download, install and configure the environments with the varios parts of the PanCancer Architecture. This system has been broken down into several GitHub projects for the sake of modularity. 

Depending on what you are intending on accomplishing you might want to setup the individual parts individually - each sub project can be installed independently. 


 
