# gdrive
Google Drive Sync via grive2

grive2 (http://bit.ly/28InB2O) does not support continuously waiting so 
this suite has been written allowing that.

By executing 'grive.sh install' grive2 is installed as per 
http://www.webupd8.org/2015/05/grive2-grive-fork-with-google-drive.html 
(procedure tested with Ubuntu 16.10) together with 'gdrive-sync.sh'.

It is possible to customise installation of 'gdrive-sync.sh' by editing 
'grive.settings.user'.

'gdrive-sync.sh' will be installed to 
${PREFIX_BIN}/${EXEC_PREFIX}gdrive-sync.sh

* INTERVAL
* TIMEOUT
* GDRIVE_DIR
* GDRIVE_LOG
* SETTINGS

are default settings for 'gdrive-sync.sh'.

Specifically 'SETTINGS' points to the file that 'gdrive-sync.sh' loads.
So it is possible to override the defaults.

By executing 'gdrive-sync.sh setup' gdrive directory (GDRIVE_DIR) is initialited and 
first synchronization starts.
Just after that is executed the 'installSync' phase where it is asked if 
continuos synchronization must be run by either cron or (ubuntu) start application.
The first append cron to the ones of the user.
The second install a start application Desktop file for the user 


# References

https://launchpad.net/~nilarimogard/+archive/ubuntu/webupd8

# ChangeLog

@author Dr. John X Zoidberg <drjxzoidberg@gmail.com>

@version 0.2.0

@date 2017-10-07
 - updated according with code changes.

@author Dr. John X Zoidberg <drjxzoidberg@gmail.com>

@version 0.1.0

@date 2017-03-01
 - first release.
