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

`
#m h dom mon dow user  command

  1  6 *   *   *   root  /usr/bin/adblock >/dev/null 2>&1
 ` 

## Installation
* download all files in this repositiry
* install by executing:

`  sudo ./install.sh install`
  
## Remove
* goto /etc/adblock
* remove by executing

`  sudo /etc/adblock/install.sh remove`
