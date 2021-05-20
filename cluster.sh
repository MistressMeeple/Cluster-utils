#!/bin/bash


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
