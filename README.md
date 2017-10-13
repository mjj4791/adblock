# adblock
DNS based adblocker for linux/dnsmasq


## Usage
The adblock process must be executed as root user (or using sudo).

`  sudo /usr/bin/adblock [command] [parameters]`

where <command> (optional):
* **start** : Start adblocking
* **stop** : Stop adblocking (remove all blocked domains)
* **status** : Show start/stop status
* **reload** : Reload all downloaded blocklists and reapply the whitelisted sites.
* **suspend** : Temporarily suspend adblocking.
* **resume** : Resume adblocking.
* **query** : Query adblock lists for domain name. Parameter: domain name
* **help** : Show this help.
* _else_ : Download and use all blacklists.


### Cron
To run the adblock update process you can add it into cron, for example:

`  vi /etc/cron.d/adblock`

in this file add:

```
#m h dom mon dow user  command
  1  6 *   *   *   root  /usr/bin/adblock >/dev/null 2>&1
 ```

## Installation
* download all files in this repositiry
* install by executing:

`  sudo ./install.sh install`
  
## Remove
* goto /etc/adblock
* remove by executing

`  sudo /etc/adblock/install.sh remove`

## Configuration
All configuration is located in `/etc/adblock/adblock.conf`.

* **#adb_tldcompression** : remove subdomains if the top level domain is already blocked
  * 0: disable toplevel domain compression
  * **1**: enable toplevel domain compression
* **adb_log2file** : Log to logfile as well (`/var/log/adblock.log`). Next to a logfile, all logging will be sent to syslog by default.
  * 0: do not log to logfile
  * **1: log to file**
* **adb_minspace** : the minimum diskpase required for adblock to start downloading and processing. Specified in 1K or 512 byte blocks, see `man df` to see which will be used on your system.
* **adb_targets** : a space separated list of all targets to execute
  * **file** : this is the default target (as part of adblock itself)
  * **_other_** : add any other target defined in this config file (see _adding targets_)
* **adb_sources** : a space separated list of all suorces to use for downloading all blocklists (see _adding sources_)

### Adding Targets
You can add multiple targets in the adblock config file. An output file of the blocked domains will we created for each target specifically, based on the created list of blocked domain names.

Per target you configure the following parameters:
* **enabled** : enable or disable this target
  * 0 : disbled
  * **1 : enabled**
* **detect** : command used to detect the presence of this target; for example detect the presence of a file or folder. This command must return an exit code 0 on success or any other code in case of failure. If no detection is required, this paramter can be left empty. If it has been configured and a non-zero exit code is returned, this target will not be executed/created.
* **format** : and formatting command understood by `awk` for converting the list of domain names into the specific format used by the target.
* **filename** : the filename of the file produced for this target (filename only, no path!)
* **dir** : the folder where the fle must be created (path only, no filename)
* **hidedir** : the folder used for suspending adblock for this target. If this parameter is left blank, the adblocking functionality cannot be suspended for this target.
* **restart** : a command to execute to restart / reinitialize the target (such as restarting a service).
* **pid** : a command used to retrieve a pid for the running target. The output of this command will be used to determine if the service was correctly started. If no command is specified, success will be asumed. If this command returns no pid, a corrupt output file is assumed and the target will be returned to the previous configuration.

Name each of the parameters per target using this convention: target\__name_\__parameter_, for example:
```
target_file_enabled=1
target_file_detect=
target_file_dir=/tmp
```


### Adding Sources
