## Setting up a Pancancer Environment

A Pancancer production environment consists of one or more "launcher" nodes, and a number of "worker" nodes controlled by a launcher. The launcher is responsible for provisioning the worker nodes, and the worker nodes execute workflows.

The launchers and workers are typically run in a cloud-computing environment such as AWS, or an OpenStack installation.

Most of the software on a launcher node is installed as a docker container. To learn more about how to set up a launcher, you can [read more about the process on the Pancancer Launcher page](https://github.com/ICGC-TCGA-PanCancer/pancancer_launcher/blob/3.1.1/README.md#pancancer-launcher).
