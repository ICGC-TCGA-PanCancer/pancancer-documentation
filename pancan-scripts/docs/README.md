# Preparing the Environment

This documentation will exmplain how to set up the environment needed for Pancancer.info to live on. It will go though all the necessary installs and downloads needed. By following this you should be able to migrate the site to whatever server you would like. Launch an instance on AWS and ssh into that instance. To configure the site onto the instance, you must do the following :

First make a directory under /home/ubuntu :
 
    $ mkdir gitroot

We then have to make some more directories in /var/www/ :

    $ cd /var/www/
    $ mkdir bubbles
    $ mkdir up_data
    $ mkdir ave_data

Clone the branch onto the machine using :

    $ git clone https://github.com/SeqWare/pancancer-info.git
    $ cd pancancer-info

Copy uploads.html to /var/www/ :

    $ cd pancan-scripts
    # need one more directory
    $ mkdir results
    $ cp uploads.html /var/www/

Before running any scripts you need to check if perl is at least version 5.18.2 using perl -v. From past experience, this version of perl has worked fine with all the perl scripts in the repo. If necessary, update perl to version 5.18.2. To do this, you need to use perlbrew. Perlbrew allows you to manage and use multiple versions perl on the same machine, if there are any problems go to http://perlbrew.pl/ to get some clarification. To use perlbrew do the following :

    # download perlbrew
    $ wget -O - http://install.perlbrew.pl | bash
    $ vim ~/.bash_profile # place this line:  source ~/perl5/perlbrew/etc/bashrc into the file
    $ sudo apt-get install perlbrew
    # initialize perlbrew environment
    $ perlbrew init

Now that perlbrew is installed, you can download perl 5.18.2 :

    # install perl-5.18.2, this may take a while ...
    $ perlbrew install perl-5.18.2
    # you can track the status using
    $ tail -f ~/perl5/perlbrew/build.log
    # start using right version 
    $ perlbrew use 5.18.2
    # check if right version 
    $ perl -v # should show you 5.18.2
    # You might also want to use cpanminus to make installing modules much easier
    $ perlbrew install-cpanm

Now that you have the right version of perl, we can begin to install all the dependencies. Before installing the modules, you need to install the following packages :

    $ sudo apt-get install libxml2-dev libexpat1-dev libcrypt-ssleay-perl libssl-dev
    
    $ cpanm Net::Google::Spreadsheets XML::DOM WWW::Mechanize Getopt::Long XML::Simple String::Util

If you are having trouble installing modules using cpanm you try to install the modules using cpan. For example :
    
    $ cpan
    $ cpan[1]> install Net::Google::Spreadsheets

You have to put in your credentials for the get_spreadsheets.pl and get_uploads.pl scripts. You will put your gmail address which has access to all the spreadsheets for the projects and your gmail password. To include the "@" symbol you need to put "\@gmail.com" into the perl script. 

Once everything is installed and ready to use, you can try and run the shell scripts :

    # make sure you are in /home/ubuntu/gitroot/pancancer-info/pancan-scripts/
    $ ./decider.cron
    $ ./run_get.sh

This should put all the necessary files in the /var/www/ directory and have the site ready for use.

You can set up a cron job running the scripts as freqeutnly as you would like using :

    $ crontab -e
    # 1 * * * * /home/ubuntu/gitroot/pancancer-info/pancan-scripts/decider.cron &> /home/ubuntu/gitroot/pancancer-info/pancan-scripts/decider.cron.log
    # this will run every first minute of every hour
    # * */2 * * * /home/ubuntu/gitroot/pancancer-info/pancan-scripts/run_get.sh > /home/ubuntu/gitroot/pancancer-info/pancan-scripts/run_get.sh.log 2>&1
    # this will run every other hour
    
You can use tail on the log files to see if the cronjobs are being run properly :

    $ tail -f /home/ubuntu/gitroot/pancancer-info/pancan-scripts/decider.cron.log
    $ tail -f /home/ubuntu/gitroot/pancancer-info/pancan-scripts/run_get.sh.log
