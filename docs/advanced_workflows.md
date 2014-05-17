# TCGA/ICGC PanCancer - Advanced Workflow Topics

## Overview

This guide includes information about several "advanced" workflow
topics.  Basically, as you make more sophisticated workflows
you may run into one or more of the items below.

## Adding External Maven Dependencies

Within OICR we use an "Artifactory" server to store Java dependencies along
with data and binary files that workflows need.  This flexibility is great
since it allows us to refer to common data files, binaries, etc in the Maven
pom.xml file.  These dependencies are then pulled into the correct location in
the workflow directory structure.

For example, here is the snippet from the pom.xml file for the samtools binary utility:

        <dependency>
            <groupId>samtools</groupId>
            <artifactId>samtools</artifactId>
            <version>0.1.19</version>
            <type>zip</type>
        </dependency>

This corresponds to the following file in Artifactory:

https://seqwaremaven.oicr.on.ca/artifactory/seqware-dependencies/samtools/samtools/0.1.19/samtools-0.1.19.zip

And this repository is made available in the pom.xml with:

        <repository>
            <id>seqwaremaven.oicr.on.ca-seqware-dependencies</id>
            <name>seqwaremaven.oicr.on.ca-seqware-dependencies</name>
            <url>http://seqwaremaven.oicr.on.ca/artifactory/seqware-dependencies</url>
        </repository>

When the workflow is built, the samtools-0.1.19.zip is downloaded automatically and unzipped to the workflow bundle directory, for example:

    Workflow_Bundle_BWA_2.4.0_SeqWare_1.0.13/Workflow_Bundle_BWA/2.4.0/bin/samtools-0.1.19/samtools

Now, within your workflow this samtools binary path looks like the following the Java workflow code:

    this.getWorkflowBaseDir() + "/bin/samtools-0.1.19/samtools

## Adding External Java Dependencies for Use During Workflow Preparation

So the issue with the above is the zip is downloaded and extracted to the "bin" directory inside the workflow.  However, 
a jar file referenced in the pom.xml is placed in the lib directory such as:

        <dependency>
            <groupId>com.github.seqware</groupId>
            <artifactId>seqware-pipeline</artifactId>
            <version>${seqware-version}</version>
            <scope>provided</scope>
        </dependency>

This jar is then placed in the "lib" directory.  This works well if, in a particular job, you want to reference your .jar file.  However
if you want to use Java tools while the workflow is planned (before it is scheduled) you need to ensure the jar is unzipped into the "classes" 
directory.  The following pom.xml fragment will let you do this:


            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>2.8</version>
                <executions>
                ...
                    <execution>
                        <id>unpack-oicr-dependencies</id>
                        <phase>package</phase>
                        <goals>
                            <goal>unpack-dependencies</goal>
                        </goals>
                        <configuration>
                            <outputDirectory>${project.build.directory}/Workflow_Bundle_${workflow-directory-name}_${project.version}_SeqWare_${seqware-version}/Workflow_Bundle_${workflow-directory-name}/${project.version}/classes</outputDirectory>
                            <overWriteReleases>false</overWriteReleases>
                            <overWriteSnapshots>true</overWriteSnapshots>
                            <includeArtifactIds>workflow-utilities</includeArtifactIds>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

Notice how "workflow-utilities" is specified and directed to the "classes"
directory.  The packages within workflow-utilities are now available in your
classpath for the workflow when it executes to prepare the workflow plan.  You
can import the objects/packages you need in your class that extends
AbstractWorkflowDataModel and defines the steps in your workflow.  ## Adding
Large File Dependencies

## Docker as Workflow Steps

## Variable Step Workflows

## Next Steps

For workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into
problems.
