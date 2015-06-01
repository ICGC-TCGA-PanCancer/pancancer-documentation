# TCGA/ICGC PanCancer - Image a node for future use

## Image the Instance for Future Use on Amazon AWS

You do not need to run Bindle to create new instances every time. You can image your machine in order to quickly deploy new instances with the exact same components in the future. 

For AWS, note that you should create an image with ephemeral drives listed if you wish to use them. The [youxia deployer](https://github.com/CloudBindle/youxia#deployer) is designed to read this information and ensure that deployed instances spin up with attached ephemeral drives, you can deploy instances using the [monitoring-bag](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag) project in order to deploy instances with monitoring and LVM deployed on ephemeral drives. 

The document at Amazon that provides additional information on this process is [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html). 

## Image the Instance for Future Use on OpenStack 

TBD

## Image the Instance for Future Use on vCloud

In order to image a VM that has been provisioned by Bindle for future use you will need to "catalogue" the image. In order to do this go to the web console (for EBI https://extcloud01.ebi.uk/cloud/org/oicr/). On the home screen right click on the vAapp that you would like to catalog and select "Add to Cataloge". For EBI select the catalog "phase2". Select "OK" after customizeing options. 

At this point you can point Bindle to spin up the new image. It will be the exact same as the machine that was use to make the cataloged image other than the drive not being mounted. 

At this point we do not have youxia to deploy VM's. Untill this is ready VM's are being spun up using Bindle itself. 

## Next Steps

### Spin up from an image with Bindle

When you have an image, it is possible to use Bindle again to spin up from that image. We have designed a smaller Ansible playbook called the [monitoring-bag](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag) to be used in this process. As the name implies, this playbook hooks up instances to Sensu and performs any remaining setup that does not survive the imaging process such as creating swap space, hooking up LVM, etc. 

The document that details this process is [here](instance_from_image_with_bindle.md).

### Spin up from an image using the Youxia deployer. 

When you have an image, it is possible to use Youxia's deployer tool to automatically deploy instances on AWS. This tool places new instances under the control of the Youxia system. For further reading, please review [Youxia](youxia.md).
