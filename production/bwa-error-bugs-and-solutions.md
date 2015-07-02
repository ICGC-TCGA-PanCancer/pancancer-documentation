#Bug: error in BWA Mem step - cannot open pipes()

#solution

    sudo vi /etc/security/limits.conf

Change end of file to:

# End of file
* soft nofile 500000
* soft nproc 500000
#* soft nofile 162305
* hard nofile 500000
* hard nproc 500000
#* hard nofile 162305

run 
    sudo service gridengine-exec restart

Retry workflow

