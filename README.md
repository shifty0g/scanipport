# scansummary

the idea of this script is to scoop up everything in the current directoy and print out ip:port/proto. It is a bit janky and is a series of ls and grep commands but to get a quick list this is simple and nice. the reason for this is to limit waitinf for scans. u can kind of run this in another tab and use it to guide ur probing of ports 

Currently it supports the following

- nmap .gnmap - it will parse through completed gnmap files 
- nmap logs - if you tee out your nmap scan `nmap -vv 192.168.0.22 | tee nmap_tcp_def.log` or use screen with a log file like `screen -L -Logfile nmap_tcp_full.log -d -m -S nmap_tcp_full nmap -vv -T4 -oA nmap_tcp_full -sT -p- -iL targets.txt` . just make sure the log file has the extention **.log**
- udpx - `udpx.log`
- udp-proto-scanner - `udp-proto-scanner.log` 
- rustscan - will grep for thhe file **rust**


I will look to evolve and improve this but currently this is a start..

Please let me know if you have any issues or suggestions :) 



## Installation

Just git clone this report and away you go 



## Useage

1) Jump into the folder where you have your scan output (nmap*.gnmap, udpx.log...est)  `cd xxx`

2) run the script `/scanipport.sh`




## Example output 

you can use it in a variety of ways as shown in the examples below

```
/scanipport.sh | grep 10.0.0.122
10.0.0.122:22/tcp
10.0.0.122:80/tcp
10.0.0.122:135/tcp
10.0.0.122:137/udp
10.0.0.122:139/tcp
10.0.0.122:161/udp
10.0.0.122:445/tcp
10.0.0.122:1025/tcp
10.0.0.122:1026/tcp
10.0.0.122:1027/tcp


/scanipport.sh | grep udp 
10.0.0.20:53/udp
10.0.0.20:67/udp
10.0.0.20:69/udp
10.0.0.20:111/udp
10.0.0.20:137/udp
10.0.0.20:161/udp
10.0.0.20:2049/udp
10.0.0.99:111/udp
10.0.0.120:53/udp
10.0.0.120:88/udp

/scanipport.sh | grep tcp | cut -d '/' -f1 | sort -u -V
10.0.0.3:1042
10.0.0.3:1043
10.0.0.3:3389
10.0.0.3:15100
10.0.0.3:15101
10.0.0.9:380
10.0.0.9:455
10.0.0.16:312
10.0.0.20:21
10.0.0.20:53
10.0.0.20:80
```