# TCGA/ICGC PanCancer - BWA-Mem Workflow SOP



## Overview

### Step - Create a New Workflow

At this point you now have a complete SeqWare/GridEngine/Hadoop environment for
creating and testing workflows in.  In this next step I will show you how to
create a new SeqWare workflow using Maven Archetypes.  These are templates that
create all the boilerplate for you so you can just focus on the contents of
your workflow rather than the setup of the various files and directories needed
to create a SeqWare workflow with Maven. You will work as the vagrant user
in the /vagrant directory (which is target-vb-1/master on your local desktop).
In this way both your desktop and the VM can share the workflow.

    # work in the /vagrant directory
    $ cd /vagrant

    # now create a new workflow from the Maven template
    $ mvn archetype:generate \
    -DinteractiveMode=false \
    -DarchetypeCatalog=local \
    -DarchetypeGroupId=com.github.seqware \
    -DarchetypeArtifactId=seqware-archetype-java-workflow \
    -DgroupId=io.seqware \
    -Dpackage=io.seqware \
    -DartifactId=MyHelloWorld \
    -Dversion=1.0-SNAPSHOT \
    -DworkflowVersion=1.0-SNAPSHOT \
    -DworkflowDirectoryName=MyHelloWorld \
    -DworkflowName=MyHelloWorld \
    -Dworkflow-name=MyHelloWorld

    # you can now compile that workflow
    $ cd MyHelloWorld
    $ mvn clean install

    # now test the workflow
    $ seqware bundle launch --dir target/Workflow_Bundle_MyHelloWorld*

The above just is the start of our documentation for workflow development using
SeqWare.  Please see http://seqware.io for much more information, in particular
look at the Developer Getting Started Guide.

### Step - Modify the Workflow on Your Desktop

Now the cool part, since /vagrant on the VM and target-vb-1/master on your
desktop host computer are shared, you can use your favorite IDE to edit the
Java SeqWare workflow.  Simply fire up your IDE (for example NetBeans) and open
up the Maven workflow you created above.  In the case of NetBeans you would use
"File.../Open Project..." and navigate to the "target-vb-1/master/MyHelloWorld"
directory which should be recognized as a Maven project.  You can then modify
the Workflow Java object, workflow.ini, and other template files all from your
nice IDE interface on your desktop computer.  When you want to compile or test
the workflow you can do this on your VM which is setup for both activities.

### Step - Test and Package Your Workflow

As with the example above, you can compile and test your workflow after you make changes.  Just repeat the mvn and seqware commands above on your VM as vagrant after you make changes in your IDE on your desktop host computer:

    # you can now compile that workflow
    $ cd /vagrant/MyHelloWorld
    $ mvn clean install

    # now test the workflow
    $ seqware bundle launch --dir target/Workflow_Bundle_MyHelloWorld*

When you are happy with your workflow you can "package" it up for distribution to other sites.

    # package the final workflow
    $ seqware bundle package --dir target/Workflow_Bundle_MyHelloWorld*

On another SeqWare VM you install this bundle using:

    # install on another VM
    seqware bundle install --zip Workflow_Bundle_MyHelloWorld*.zip

The above just is the start of our documentation.  Please see http://seqware.io
for much more information, in particular look at the Developer Getting Started
Guide.

## Next Steps

Much more information can be found in the README for the Bindle
project, see https://github.com/SeqWare/vagrant

For workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into
problems.
