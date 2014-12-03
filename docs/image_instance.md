# TCGA/ICGC PanCancer - Image a node for future use

## Image the Instance for Future Use on Amazon AWS

You do not need to run Bindle to create new instances every time. You can image your machine in order to quickly deploy new instances with the exact same components in the future. 

For AWS, note that you should create an image with ephemeral drives listed if you wish to use them. The [youxia deployer](https://github.com/CloudBindle/youxia#deployer) is designed to read this information and ensure that deployed instances spin up with attached ephemeral drives, you can deploy instances using the [monitoring-bag](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag) project in order to deploy instances with monitoring and LVM deployed on ephemeral drives. 

The document at Amazon that provides additional information on this process is [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html). 

## Image the Instance for Future Use on OpenStack 

TBD

## Image the Instance for Future Use on vCloud

TBD

## Next Steps

### Spin up from an image with Bindle

When you have an image, it is possible to use Bindle again to spin up from that image. We have designed a smaller Ansible playbook called the [monitoring-bag](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag) to be used in this process. As the name implies, this playbook hooks up instances to Sensu and performs any remaining setup that does not survive the imaging process such as creating swap space, hooking up LVM, etc. 

The document that details this process is [here](instance_from_image_with_bindle.md).

### Spin up from an image using the Youxia deployer. 

When you have an image, it is possible to use Youxia's deployer tool to automatically deploy instances on AWS. This tool places new instances under the control of the Youxia system. For further reading, please review [Youxia](youxia.md).
