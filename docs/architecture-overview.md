# PanCancer Architecture

## DESCRIPTION

The architecture containes to main parts. The GNOS servers that host all of the data and the clusters that process the data. 

### GNOS

There are several GNOS servers around the world which host the PanCancer data. They can be accessed client tools such as "cgquery".

### Cloud Environments

The code for the cloud environments have been created for VirtualBox, vCloud, OpenStack and AWS. 

#### Development

Virtual Box is supported to allow workflow developers the abililty to spin up a SeqWare on thier own computer. 

#### Provisioning

[Architecture Provisioning Scripts](https://github.com/ICGC-TCGA-PanCancer/architecture-setup) have been created to download, install and configure the environments with the varios parts of the PanCancer Architecture. This system has been broken down into sever GitHub projects for the sake of modularity. 

Depending on what your intending on accomplishing you might want to setup the individual parts individually - each sub project can be in stalled independently. 


 
