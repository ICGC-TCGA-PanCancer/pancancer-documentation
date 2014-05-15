# TCGA/ICGC PanCancer - Workflow Approach

The PanCancer project is uniquely challenging due to the fact that it is inherently distributed.  Raw lane-level BAM files have been uploaded to a variety of Cloud environments, no single environment is sufficiently large enough to encompass the full dataset.  For this reason it is extremely valuable to use a workflow system that can span multiple cloud evironments without requiring modifications of the workflows to work in each.  We chose SeqWare as the defacto standard for workflows during "Phase II" of the project since it affords this level of abstraction and portability.  It is also supported in the Bindle project meaning we have good tool support for building SeqWare virtual clusters across these clouds.

## Workflow Environment

Bindle can be used to create a workflow development environment that
can be used to create SeqWare workflows or other tools. These can be used in
Phase II activities (for SeqWare workflows) or Phase III (SeqWare workflows or
other tools).  These Bindle-created virtual clusters running on the clouds provide both GridEngine and Hadoop along with the various SeqWare components out of the box.

## Workflow Framework

The reason PanCancer is using SeqWare workflows specifically for Phase II is it
provides a mechanism to define an analytical workflow that combines a variety
of tools.  It is tool agnostic, you can make workflows with whatever components
you like.  These workflows are then "packaged" into a zip file format that the
SeqWare system recognizes and knows how to run.  In this way SeqWare workflows
are portable between SeqWare environments, allowing us to move updated or new
workflows between the various PanCancer cloud environments.  Groups that create
SeqWare workflows can exchange the workflows and can be assured they will run
across all the various Bindle-created environments. SeqWare workflows
also integrate with metadata tracking tools and deciders, allowing for
automated triggering.  This allows us to detect new samples in Phase II, launch
clusters using Bindle, and then automatically run workflows on those
environments.

You can find more information on how to build SeqWare workflows and use the
SeqWare tools at our project website http://seqware.io.
