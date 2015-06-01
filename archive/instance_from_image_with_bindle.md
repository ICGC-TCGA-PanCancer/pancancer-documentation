# Start instances from an image with Bindle

In certain environments, it can be advantageous to start instances from a pre-created image using Bindle. Specifically, the Youxia deployer currently supports only AWS. This guide details how to configure Bindle to start-up from an instance, also covering settings for the monitoring-bag that are unique to specific environments. 

## Start instances from an image on vCloud at EBI

Currently we are using Bindle to spin up images on vcloud (https://github.com/CloudBindle/Bindle). We are using the catalogued vApp pancancer\_vcf to spin up images. This vAPP contains a ubuntu 12.04 image and a half a terabyte hardrive. We are mounting this efemeral disk with the pancancer\_bag that is used by Bindle. 

## Start instances from an image on OpenStack 

TBD
