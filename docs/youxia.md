## Youxia ##

Pancancer uses the youxia suite of software tools to deploy, monitor, and teardown clusters on (Amazon) AWS.
Please refer to [Youxia](https://github.com/CloudBindle/youxia) for generic documentation for Youxia.

Here, we will document any specific steps taken for the deployment for pancancer with Ireland as a case study.

### Ireland ####

0. Create an AMI image. For this step, we used [Bindle](https://github.com/CloudBindle/Bindle#persistance-of-ephemeral-disks---aws) deploying to an instance with a persistent EBS root filesystem. We used version 2.0-alpha.1 of Bindle paired with the 1.0-alpha.1 of [pancancer-bag](https://github.com/ICGC-TCGA-PanCancer/pancancer-bag). Note that some changes were required to seqware-bag subsequent to [1.0-alpha.2](https://github.com/SeqWare/seqware-bag/releases/tag/1.0-alpha.2) and are documented by the following commits.
1. While proceeding through the youxia docs 
  1. Configure an integration for a Slack channel. In our case, we created a channel called #youxia-flying-snow and an Incoming WebHook which is specified in the youxia config file.
  2. Deploy an instance on Amazon and use the youxia-setup playbook against it to deploy all youxia components. We deployed youxia 1.1.0-alpha.3 with a slightly patched reaper.
  3. Modify the crontab for the ubuntu user as required to specify the number of hosts that should be maintained
  4. Modify the crontab to disable the mock decider when you are satisfied with the operation of youxia
2. Hook up a decider from within the paired academic cloud.  
  1. For this step, ensure that the environment has access to Java 7. Download the jar files from artfiactory as documented in the youxia documentation and configure the generator component only.
3. Hook up the decider as required.
4. ???
