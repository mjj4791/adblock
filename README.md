# adblock
DNS based adblocker for linux/dnsmasq

### Blocklists
The adblocker supports many blocklists by default, you are able to enable or disable them in the configuration, see [Configuration](#configuration) below.

The following blocklists can be consumed at this moment in time:
* [AdAway](https://adaway.org/)
* [AdGuard](https://github.com/AdguardTeam/AdguardDNS)
* [Disconnect](https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt)
* [Dshield](https://secure.dshield.org/suspicious_domains.html)
* [Easylist](https://easylist.to/)
  * generic
  * dutch
  * german
  * polish
  * romanian
  * russian
  * chinese
  * fanboy: Fanboy's Annoyances (blocks in-page pop-ups, social media and related widgets, and other annoyances)
  * malware domain list
* [Feodo Tracker](https://feodotracker.abuse.ch/)
* [hpHosts](https://hosts-file.net/)
* [malwaredomains](https://mirror.cedia.org.ec/malwaredomains)
* [openPhish](https://openphish.com)
* [Peter Lowe's list](http://pgl.yoyo.org/adservers/)
* [Randsomeware tracker](https://ransomwaretracker.abuse.ch/)
* [Secure mecca](http://securemecca.com/)
* [Shalla](http://www.shallalist.de)
* [Spam404](https://github.com/Dawsey21/Lists)
* [Steve Black](https://github.com/StevenBlack/hosts)
  * [Spotify Ads](https://github.com/StevenBlack/hosts/tree/master/data/SpotifyAds)
  * [Gambling](https://github.com/StevenBlack/hosts/tree/master/extensions/gambling)
  * [tyzbit](https://github.com/StevenBlack/hosts/tree/master/data/tyzbit)
* [sysctl](http://sysctl.org/cameleon/)
* [whocares](http://someonewhocares.org/hosts)
* [WindowsSpyBlocker](https://github.com/crazy-max/WindowsSpyBlocker/tree/master/data/hosts/win10)
* [winhelp2002](http://winhelp2002.mvps.org/)
* [yoyo](https://pgl.yoyo.org/adservers/)
* [ZeusTracker](https://zeustracker.abuse.ch)


#### Whitelist
Using the whitelist, you are able to whitelist domains that are blocked by one or more of the dowloaded blocklists. The domains listed in the whitelist will not get blocked; the whitelist gets applied after all blocklists are downaloded and combined into one big blocklist.

The whitelist is located in `/etc/adblock/adblock.whitelist`. Domains you want to whitelist can be added one domain per line.

#### Blacklist
The blacklist is located in `/etc/adblock/adblock.blacklist`. Domains you want to blacklist manually can be added one domain per line.
On order for the blacklist to be considered, you bave to enable the blacklist and add the blacklist file as a source in the `adb_sources`  setting (see below).


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

## Installation
* download all files in this repositiry
* install by executing:

`  sudo ./install.sh install`

### Cron
To run the adblock update process you can add it into cron, for example:

`  vi /etc/cron.d/adblock`

in this file add:

```
#m h dom mon dow user  command
  1  6 *   *   *   root  /usr/bin/adblock >/dev/null 2>&1
 ```

## Remove
* goto /etc/adblock
* remove by executing

`  sudo /etc/adblock/install.sh remove`

## Configuration
All configuration is located in `/etc/adblock/adblock.conf`.

* **adb_tldcompression** : remove subdomains if the top level domain is already blocked
  * 0: disable toplevel domain compression
  * **1**: enable toplevel domain compression
* **adb_log2file** : Log to logfile as well (`/var/log/adblock.log`). Next to a logfile, all logging will be sent to syslog by default.
  * 0: do not log to logfile
  * **1: log to file**
* **adb_minspace** : the minimum diskpase required for adblock to start downloading and processing. Specified in 1K or 512 byte blocks, see `man df` to see which will be used on your system.
* **adb_targets** : a space separated list of all targets to execute
  * **file** : this is the default target (as part of adblock itself)
  * **_other_** : add any other target defined in this config file (see [adding targets](#adding-targets))
* **adb_sources** : a space separated list of all suorces to use for downloading all blocklists (see [adding sources](#adding-sources)

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
target_file_format='{ print $0 }'
target_file_filename=blocklist.conf
target_file_dir=/tmp
target_file_hidedir=
target_file_restart=
target_file_pid=

target_dnsmasq_enabled=1
target_dnsmasq_detect='which dnsmasq'
target_dnsmasq_format='{ print "local=/"$0"/" }'
target_dnsmasq_filename=adblock.conf
target_dnsmasq_dir=/etc/dnsmasq.d
target_dnsmasq_hidedir=/etc/dnsmasq.d/.adb_hidden/
target_dnsmasq_restart='service dnsmasq restart'
target_dnsmasq_pid='pidof dnsmasq'
```

### Adding Sources
In the config file you can add as many blockllist sources you want.
Each enabled and configured source will be downloaded and combined into one large list of blocked domains.

for each source, configure the following parameters:
* **enabled\__source_** : enable (1) or disable (0) this source blocklist
* **adb\_src\__source_** : the url to download the blocklist for this source
* **adb\_src\_rset\__source_** : an `awk`  comattible command to transform the lines in the source file into a clean list of domain names (one name per row).
* **adb\_src\_desc\__source_** : a textual description for this source


Name each of the parameters per source using the convention shown below:
```
enabled_adaway=1
adb_src_adaway='https://adaway.org/hosts.txt'
adb_src_rset_adaway='{sub(/\r$/,"")};$0 ~/^127\.0\.0\.1[ \t]+([A-Za-z0-9_-]+\.){1,}[A-Za-z]+/{print tolower($2)}'
adb_src_desc_adaway='focus on mobile ads, infrequent updates, approx. 400 entries'

```
