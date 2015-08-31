## Setting up a Pancancer Environment

A Pancancer production environment consists of one or more "launcher" nodes, and a number of "worker" nodes controlled by a launcher. The launcher is responsible for provisioning the worker nodes, and the worker nodes execute workflows.

The launchers and workers are typically run in a cloud-computing environment such as AWS, or an OpenStack installation.

Most of the software on a launcher node is installed as a docker container.

To install this docker container, you can use the Quick Start guide for the [PancancerCLI](https://github.com/ICGC-TCGA-PanCancer/cli/blob/0.0.1/QuickStart.md). **This is the recommended process for most users.**

Developers may find it useful to read the [detailed pancancer launcher guide](https://github.com/ICGC-TCGA-PanCancer/pancancer_launcher/blob/3.1.3/README.md#pancancer-launcher).
