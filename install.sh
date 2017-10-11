#!/bin/bash

curdir=`dirname $0`
confdir=/etc/adblock
adb_dnsdir=/etc/dnsmasq.d
adb_dnshidedir=${adb_dnsdir}/.adb_hidden
file_adblock=adblock
file_adblockconf=adblock.conf
file_adblockwhitelist=adblock.whitelist
file_adblockblacklist=adblock.blacklist
file_adblockinstall=install.sh
    
# f_usage: show usage info
f_usage() {
    echo "$0 [command]"
    echo " "
    echo "where [command] in:"
    echo "  install : install adblock"
    echo "  remove  : remove adblock"
    echo
    exit 0
}

# f_checkuser: check executing user
f_checkuser() {
	USR=`whoami`
	if [ $USR != 'root' ]; then
		echo "This script must be executed by user 'root' (you are $USR)!"
		echo
		echo "Please execute as user root, or execute:"
		echo "sudo $0 $*"
		exit 1
	fi
}

# f_checkinstall: check if all files are present before installing
f_checkinstall() {
    
    if [ ! -f "$curdir/$file_adblock" ]; then
        echo ERROR: missing adblock file [$curdir/$file_adblock]!
        exit 1
    fi
    if [ ! -f "$curdir/$file_adblockconf" ]; then
        echo ERROR: missing adblock file [$curdir/$file_adblockconf]!
        exit 1
    fi
    if [ ! -f "$curdir/$file_adblockwhitelist" ]; then
        echo ERROR: missing adblock file [$curdir/$file_adblockwhitelist]!
        exit 1
    fi
    if [ ! -f "$curdir/$file_adblockblacklist" ]; then
        echo ERROR: missing adblock file [$curdir/$file_adblockblacklist]!
        exit 1
    fi
}

# f_install: install adblock
f_install() {
    echo Installing adblock...
    
    f_checkinstall
    
    mkdir -p $confdir 2>&1 >/dev/null
    
    cp $curdir/$file_adblock /usr/bin
    cp $curdir/$file_adblockconf $confdir
    cp $curdir/$file_adblockblacklist $confdir
    cp $curdir/$file_adblockwhitelist $confdir
    cp $curdir/$file_adblockinstall $confdir
    
    chmod +x /usr/bin/$file_adblock
    chmod +x $confdir/$file_adblockinstall
    
    echo Adblock installed.
}

# f_remove: remove adblock
f_remove() {
    echo Removing adblock...
    rm -f /usr/bin/$file_adblock 
    
    echo
    echo "Remove adblock config files as well (y/N)?"
    read rmconfig

    if [[ "$rmconfig" == "y" || "$rmconfig" == "Y" ]]; then
        echo Removing config files...
        rm -rf "$confdir/*" 2>/dev/null
        rm -rf "$confdir/lists/*" 2>/dev/null
        rm -rf "$adb_dnshidedir/*" 2>/dev/null
        
        rmdir "$adb_dnshidedir" 2>/dev/null
        rmdir "$confdir/lists/" 2>/dev/null
        rmdir "$confdir" 2>/dev/null
    fi
    echo Adblock removed.
}

f_checkuser
case "$1" in
    install)
        f_install
        ;;
    remove)
        f_remove
        ;;
    *)
        f_usage
esac

