# TCGA/ICGC PanCancer - Advanced Workflow Topics

## TODO

* add a section on storing reference/data/test files in GNOS when they are protected access

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
AbstractWorkflowDataModel and defines the steps in your workflow.  

## Adding Large File Dependencies

So pulling in binary and Java dependencies with Maven is really easy and streamlined (assuming you have an Artifactory server to host the artifacts!).  However, there is one critical flaw for this process that affects PanCancer workflows in particular.  PanCancer workflows typically have very large dependency files, e.g. genome reference files for BWA for example.  You cannot check these large binary files into Git and you, unfortunately, cannot use Artifactory for large (>500M) files.  Also, Maven does not deal well with large files, every time you build the workflow with "mvn clean install" large files are copied to the "target" directory, something that is not desirable for large file dependencies.

There is a way around this using a combination of a custom download script and a Maven plugin that avoids copying large files.  You can see this approach in the BWA workflow which is available in our public repository: http://github.com/SeqWare/public-workflows

First, we host several large reference files in Amazon S3, essentially a web server that can host public URLs for downloading the files e.g.: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz

We then created a simple downloader script that downloads a series of these files:

    #!/usr/bin/perl

    use strict;

    my ($link_dir) = @ARGV;

    check_tools();

    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.fai");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.amb");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.ann");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.bwt");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.pac");
    download("$link_dir/reference/bwa-0.6.2", "http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.sa");
    download("$link_dir/testData", "https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/synthetic_bam_for_GNOS_upload/sample_bam_sequence_synthetic_chr22_normal.tar.gz");
    system("tar zxf $link_dir/testData/sample_bam_sequence_synthetic_chr22_normal.tar.gz -C links/testData/");

    sub download {
      my ($dir, $url) = @_;
      system("mkdir -p $dir");
      $url =~ /\/([^\/]+)$/;
      my $file = $1;

      print "\nDOWNLOADING HEADER:\n\n";
      my $r = `curl -I $url | grep Content-Length`;
      $r =~ /Content-Length: (\d+)/;
      my $size = $1;
      print "\n+REMOTE FILE SIZE: $size\n";
      my $fsize = -s "$dir/$file";
      print "+LOCAL FILE SIZE: $size\n";

      if (!-e "$dir/$file" || -l "$dir/$file" || -s "$dir/$file" == 0 || -s "$dir/$file" != $size) {
        my $cmd = "wget -c -O $dir/$file $url";
        print "\nDOWNLOADING: $cmd\nFILE: $file\n\n";
        my $r = system($cmd);
        if ($r) {
          print "+DOWNLOAD FAILED!\n";
          $cmd = "lwp-download $url $dir/$file";
          print "\nDOWNLOADING AGAIN: $cmd\nFILE: $file\n\n";
          my $r = system($cmd);
          if ($r) {
            die ("+SECOND DOWNLOAD FAILED! GIVING UP!\n");
          }
        }
      }
    }

    sub check_tools {
      if (system("which curl") || (system("which lwp-download") && system("which wget"))) {
        die "+TOOLS NOT FOUND: Can't find curl and/or one of lwp-download and wget, please make sure these are installed and in your path!\n";
      }
    }

This downloader can be called at workflow build time using the following snippet in the pom.xml file:

            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>1.2.1</version>
                <executions>
                    <execution>
                        <id>download_data</id>
                        <phase>package</phase>
                        <goals>
                            <goal>exec</goal>
                        </goals>
                        <configuration>
                            <executable>perl</executable>
                            <commandlineArgs>${basedir}/workflow/scripts/download_data.pl ${basedir}/links</commandlineArgs>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

So this downloads these files to a "links" directory. These files are then linked to at build time and this saves the step of copying large files each time you execute the "mvn clean install" process.

            <plugin>
                <groupId>com.pyx4j</groupId>
                <artifactId>maven-junction-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>link</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>unlink</id>
                        <phase>clean</phase>
                        <goals>
                            <goal>unlink</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <links>
                        <link>
                            <dst>${project.build.directory}/Workflow_Bundle_${workflow-name}_${project.version}_SeqWare_${seqware-version}/Workflow_Bundle_${workflow-directory-name}/${project.version}/data</dst>
                            <src>${basedir}/links</src>
                        </link>
                    </links>
                    <packages>
                        <package>
                            <name>symlinks</name>
                            <src>${basedir}/workflow/links</src>
                        </package>
                    </packages>
                </configuration>
            </plugin>

So this means the "data" directory refered to is actually a symlink to "links" and this makes it very fast to build the workflow.  When the workflow is packaged using the SeqWare command line the "links" symlink is traversed and the large data files are correctly brought into the .zip workflow bundle.

In the future it would be nice to streamline this process perhaps with a custom Maven plugin that will handle large file dependencies through simplified

## Docker as Workflow Steps

This is pretty cool!  Docker is a new-ish semi-virtualization technology that is designed to make it easy to encapsulate tools into a light-weight VM.  Unlike a traditional VM (think OpenStack, KVM, or VirtualBox) the Docker image is designed to run within a host operating system and does not provide the same level of virtualization typically seen in these other VM environments.  The net effect is a faster, light-weight way to package up a series of tools that may have distinct library requirements.  You can then run this Docker image in a host VM.

We are using Docker to build workflows with complex steps encapsulated in distinct Docker images.  This means we can have individual steps of a workflow that have different software/library requirements yet we can run these on the same VM-based virtual clusters.  This is extremely powerful because it leverages cloud technology to build virtual clusters that are homogenious while, at the same time, having a variety of tools/libraries/software available from workflow authors running on top of this virtual environment.

Here is an example of a docker step within the workflow Java object.

    // a Docker job, for the current prototype it's just a standard bash job
    Job dockerJob2 = this.getWorkflow().createBashJob("dockerJob2");
    // use the "docker load" command to load a Docker image from within the workflow bundle directory
    dockerJob2.getCommand().addArgument("docker load -i " + this.getWorkflowBaseDir() + "/workflows/postgres_image.tar; ");
    // now run a given command within this Docker VM, capture the output to a file
    dockerJob2.getCommand().addArgument("docker run --rm eg_postgresql ps aux | grep postgres").addArgument(" > ").addArgument("dir1/ps_out");

NOTE: this work is bleeding edge and is not considered a feature of the released version of SeqWare & Bindle. This will change over time but keep this in mind as you build your workflows.

## Variable Step Workflows

This is tough for the SeqWare workflow system but not insurmountable. The issue is, for a given workflow, we may want to have a given step that produces n output files, where n is an unknown number when we launch the workflow.  Typically, this is a step that divides output by a fixed size, making it difficult to predict how many output files will be created. We have found a large number of workflows actually do not need to do this, the split number, for example, can often times simply be specified ahead of time.

What makes this difficult for SeqWare is the workflow Java definition is used to create a workflow plan which is then fixed and sent to be executed on the cluster.  This makes it very difficult to have variable numbers of subsequent steps based on the output size for a previous step within the workflow.  
There are a few ways to deal with this. First, work around it by parameterizing the split based on a variable you pass in via the workflow.ini.  For example, you might pass in splits=5 and therefore you scatter step in the workflow would know it should divide into 5 equal size inputs and the gather step right after knows there will be 5, consistently named input files that can be looped over in the workflow Java code.

Another approach would be to loop over the maximum number of steps you would need.  If the input for that step was not created then the job would simply exit without error.

NOTE: Neither of these approaches is very satisfying but they represent compromises. In the long term we anticipate using workflows inside of workflows to solve this problem robustly. Since the inner workflow is scheduled when the previous variable-output step has completed, the inner workflow is able to know the number of input files. This will require a new version of SeqWare but the approach is being prototyped now.

## Next Steps

For workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into problems.

Also, make sure you email the mailing list if you have questions about advanced workflow techniques so we can document best practices here.
