#!/bin/bash

# ClusterCTRL base dir
ClusterBase=/var/lib/clusterctrl/

# NFS Base dir
NFSBase=$ClusterBase/NFS
# NFS Name scheme: /var/lib/clusterctrl/nfs/?
NFSName=/pX

# Overlay FS base dir
OFSBase=$ClusterBase/OFS
# OFS Name scheme: /var/lib/clusterctrl/ofs/?
NFSName=/node.X

# Size limit file base dir
SLBase=$ClusterBase/SL
# OFS Name scheme: /var/lib/clusterctrl/sl/?
SLName=/node.X#.ext4


function logs(){
    tail -f /var/log/daemon.log /var/log/kern.log
}
function ssh(){
    for N in 1 2 3 4; do
        ssh pi@p$N $1;
    done
}

function on(){ 
    clusterctrl on $@
}

function off(){
    clusterctrl off $@
}

function shutdown(){    
    for N in 1 2 3 4; do
        # if /dev/ttyp$N exists then
           ssh pi@p$N sudo shutdown now;
           #wait till /dev/ttyp$N goes away
           clusterctrl off p$N
        #fi
    done
}

function minicon(){
    minicom $@
}

function setup(){    
    for N in 1 2 3 4; do
        ssh pi@p$N "echo 'do the setups'";
    done
}

function resize_size_limits(){
    # shutdown nodeN
    # umount $OFSBASE/$OFSName dir
    # e2fsck -f /var/virtual_disks/directory_with_size_limit.ext3
    # resize2fs -p /var/virtual_disks/directory_with_size_limit.ext3 NEW_SIZE
    # mount -o loop,rw,usrquota,grpquota /var/virtual_disks/directory_with_size_limit.ext3 /path/of/mount/point
}

function status(){
    clusterctrl status $@
}
function alert(){
    clusterctrl alert $@
}
function hub(){
    clusterctrl hub $@
}
function led(){
    clusterctrl led $@
}
