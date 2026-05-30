# docker-subversion
Docker for Subversion, based on slim Debian

Note: Old SaslDb-files which work on 2.1.26 may not be readable by 2.1.27. 'sasldblistusers2' will report eror if file is unreadable. 


## How To build docker image again

* run build.sh or just release.sh
 
## How To run

* Possibly copy needed sasl files to etc subfolder
* Possibly edit/remove -v volumes in run.sh for your needs, such as adding or removing sasl-files.
* run run.sh

