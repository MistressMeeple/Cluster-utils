

# Cluster-utils
My utilities for ClusterCTRL for the RasPi, sits atop the ClusterCTRL command(s), which can be found at [The ClusterCTRL github](https://github.com/burtyb/clusterhat-image/blob/master/files/usr/sbin/clusterctrl)

## Commands
All commands are a sub command of ```cluster```, so the ```logs``` command would be ```cluster logs```
Command Name | Description
------------ | ------------ 
[logs](#logs) 										| Runs ````tail -f /var/log/daemon.log /var/log/kern.log```` as detailed in https://8086.support/index.php?action=faq&cat=23&id=97&artlang=en
[on [node] [node...]](#pwer)									| Alias for ```clusterctrl on [p1..p4]```<br> Turns on all or the specified space-seperated-list of nodes
[off [node] [node...]](#power) 									| Alias for ```clusterctrl off [p1..p4]```<br> Turns on all or the specified space-seperated-list of nodes. <br><B>NOTE:</b> this performs a hard shutdown, for safe shutdown use ```safe-off```
[shutdown [node] [node...]](#power)  						| Sends shutdown command to the specified (or all if unspecified) node(s), awaits the full shutdown and then turns off the node.
[ssh \<cmd\>](#ssh) <BR>[ssh [node] \<cmd\>](#ssh) 							| Sends the command to all, or the specified space-sperated-list, node(s) through ssh on the internal network
[minicom node](#ssh) 										| Just an alias for ```minicom px```, here for convenience 
[setup \<all \| module\> [node] [node...]](#setup)  						| Configures all, or the specified space-sperated-list of, node(s) with the chosen sub modules, or all if unspecified
[status [node] [node...]](#status) 								| Displays the status of all, or the specified space-sperated-list, node(s). 
[alert on\|off [node...]](#Alert)								| Turns on or off the Alert LED for all nodes, or just the specified ones
[hub on\|off\|reset](#hub)									| USB hub can be turned on/off on Cluster HAT and reset on CTRL
[led on\|off ](#LED)										| Enables or disables all LED's


\* ```node``` can be referenced with any of the following, `nodeX`, `pX`, `X` or `node.X`, where `X` is the node's index. 
e.g. `node1`, `p2`, `3`,`node.4`


## Logs

This performs as basically an alias for ````tail -f /var/log/daemon.log /var/log/kern.log```` which is noted in [How do I USBBOOT Pi Zeros without SD cards](https://8086.support/index.php?action=faq&cat=23&id=97&artlang=en) on the ClusterCTRL wiki. 
It is very useful to see what is happening when USB boots start and how far they get, including some errors. 


## Power
The 3 commands for controlling power are ```on``` , ```off``` and ```shutdown```. 
&nbsp;	| Usage 		| Examples		| What it does
--------|-----------------------|-----------------------| -
on	| `cluster on [node...]`|`cluster on p3 p4`	| Turns *on* the specified nodes, or all, by turning *on* the power to the USB header(s) of the node(s)
off	| `cluster off [node..]`|`cluster off`		| Turns *off* the specified nodes, or all, by turning *off* the power to the USB header(s) of the node(s)
shutdown|`cluster shutdown node[..]`|`cluster shutdown node2`| Sends a *shutdown* command to specified nodes (or all), awaits confirmation and then turns the USB header(s) off
Shutdown was added to allow a nicer way to shutdown the nodes as it is known sudden power loss to Pi's can corrupt their SD'cards, and I also dont want to take the risk when using USB-Booting either. 


## SSH
Sends the command (preferably surrounded with quotes) to the specified nodes, or all. 
Basically an alias for the ```SSH``` command it self. 
When sending commands to multiple nodes it does it synchronously, i.e. it will send the command to first node,  await its completion, and then progress onto the next node
Usage|Examples
--|--
```cluster ssh 'command'```<br>```cluster ssh [node] command```|```cluster ssh 'uptime && apt show git'```<br>```cluster ssh node2 'ls' ```

## Minicom
An alias for the raw ```minicom pX``` command , all the setup should have already been done by the installation process. 
Usage | Example
--|--
```cluster minicom [node]```| ```cluster minicom node4```

## Setup
All of the following commands and functions were designed to be used together. All commands are case-*insensitive*.

Usage | Examples
--|--
```cluster setup (all | sub command) [node...]```|```cluster setup all node3```<br>```cluster setup USBBoot```<br>```cluster setup SSH p2 node.4```

##### All
Performs *all* of the setup subcommands in the following order:
1. [SSH](#SSH)
2. [USB Boot](#USB-Boot)
3. [Overlay](#overlay)
4. [Size Limit](#size-limit)

### SSH
---
This just edits the `/etc/hosts` on the controller to hold the node IP-v4 information for all, or just the specified, node(s)

##### USB Boot
---
Performs the following (as outlined on the wiki: [How do I USBBoot | ClusterHat](https://8086.support/index.php?action=faq&cat=23&id=97&artlang=en))
Steps|Command to run  
--|--
1. Cleans existing node| ```sudo rm -rf /var/lib/clusterctrl/nfs/p1/*```
2. Pull USB Boot image|  ```sudo wget https://dist.8086.net/clusterctrl/usbboot/buster/2020-02-13/ClusterCTRL-2020-02-13-lite-1-usbboot.tar.xz -O /var/lib/clusterctrl/usb-image.tar.xz```
3. Extracts image| ```sudo tar -axf /var/lib/clusterctrl/usb-image.tar.xz -C /var/lib/clusterctrl/nfs/p1/```
4 .Init USBBoot| ```sudo usbboot-init 1```
5. Enable SSH | ```sudo touch /var/lib/clusterctrl/nfs/p1/boot/ssh```
</br>

Command Arguments

Args|What it does| Example
--|--|--
\-i <br> \-\-image=  | Sets where the image to use is, with 2 options. <br> - If this is an *external* URL then replaces the default URL in step 2. <br> - If this is a *local* URL, step 2 is skipped and step 3 uses the specified file. | ```-i https://dist.8086.net/clusterctrl/usbboot/buster/2020-02-13/ClusterCTRL-2020-02-13-lite-1-usbboot.tar.xz```<br>```--image /home/pi/downloads/usbimage.tar.xz```
\-d <br> \-\-directory=|Sets where the node's directory is. This defaults to ```/var/lib/clusterctrl/nfs/p1```. This changes the extracted directory in step 3 and where to create ssh file in step 5. <br>Note: If this is changed you will have to manually change the ```/etc/exports``` file appropriately.| ```-d /nfs/node.1```<br>```--directory=/var/lib/nfs/p1```
 
##### Overlay

##### Size limit

