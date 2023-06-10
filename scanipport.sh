#!/bin/bash
VERSION="0.1"
DATE="10/06/23"

: '
This is a dirty script to scoop up every file in the current folder and try to give a nice ip:port/proto list


To do
===========
check for masscan
check for rustscan 
maybe a a way to do it via xml and nmap .. this is so u can get all variants of them 
add in nessus somehow - will need to look into xml stuff 


'

# make things all fresh 
rm -rf /tmp/scantemp.txt /tmp/list 2>/dev/null && touch /tmp/scantemp.txt 


# nmap tcp .log
[ ! -z "$(ls | grep nmap | grep tcp | grep log)" ] &&  cat $(ls | grep nmap | grep tcp | grep log)  | grep -a "Discovered open port" | cut -d ' ' -f4,6 | column -t | rev | sort -u | rev |  perl -ane 'print "$F[1] $F[0]\n"' | tr ' ' : | sort -u >> /tmp/scantemp.txt 



# nmap udp .log
[ ! -z "$(ls | grep nmap | grep udp | grep log)" ] &&  cat $(ls | grep nmap | grep udp | grep log)  | grep -a "Discovered open port" | cut -d ' ' -f4,6 | column -t | rev | sort -u | rev |  perl -ane 'print "$F[1] $F[0]\n"' | tr ' ' : | sort -u >> /tmp/scantemp.txt 





# Nmap Gnmap files 
if [ ! -z "$(ls | grep gnmap)" ]
then

# gnmap files.. just grab all of them 
cat *.gnmap 2>/dev/null | grep Ports: | grep /open/ > /tmp/list


while read line; do
	export IP=$(echo $line | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")		
	echo $line | grep $IP | tr ' ' \\n | grep -v filtered | grep open | cut -d/ -f1,3 > tports 2>/dev/null
	xargs printf -- $IP':%s \n' < tports > temp 2>/dev/null
	cat temp | sort -u -V >> /tmp/scantemp.txt  && rm -rf temp tports 2>/dev/null >/dev/null 
		
done < /tmp/list

rm -rf /tmp/list 2>/dev/null
fi




# udpx
[ ! -z "$(ls | grep udpx)" ] && cat $(ls | grep udpx) 2>/dev/null | grep \[*\] | awk {'print $4"/udp"'} | sort -u >> /tmp/scantemp.txt 



# udp proto scanner 
[ ! -z "$(ls | grep udp | grep proto)" ] && cat $(ls | grep udp | grep proto) | grep from | awk {'print $10'} | cut -d: -f1,2 | awk {'print $1"/udp"'}  >> /tmp/scantemp.txt 



# rustscan 
[ ! -z "$(ls | grep rust)" ] && cat $(ls | grep rust) | grep -i open | awk {'print $2'} | awk {'print $1"/tcp"'} >> /tmp/scantemp.txt 




# tidy everything up at the end 
cat /tmp/scantemp.txt | sort -u -V | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tr -d ' ' | grep 'tcp\|udp' | sort -u -V |  tee scanipport.txt


# cleanup 
rm -rf /tmp/scantemp.txt /tmp/list 2>/dev/null