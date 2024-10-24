#!/usr/local/bin/bash

. /usr/local/etc/opn-arp.conf

CURRENT4="/tmp/current_arp_table4.txt"
STATIC4="/tmp/static_arp_table4.txt"
OUT4="/tmp/result_arp_table4.txt"

CURRENT6="/tmp/current_arp_table6.txt"
STATIC6="/tmp/static_arp_table6.txt"
OUT6="/tmp/result_arp_table6.txt"


touch $CURRENT4
touch $STATIC4
touch $OUT4

touch $CURRENT6
touch $STATIC6
touch $OUT6

while true
do
  if [ -z "$interfaces" ]
  then
    arp -an | grep -v 'incomplete' | grep -v 'permanent' | awk '{print $2 $4}' > $CURRENT4
    ndp -an | grep -v 'incomplete' | grep -v 'permanent' | grep -v 'Neighbor' | awk '{print $1 $2}' > $CURRENT6
  else
    for a in $interfaces
    do
      echo $a
      arp -an | grep -v 'incomplete' | grep -v 'permanent' | grep $a | awk '{print $2 $4}' >> $CURRENT4
      ndp -an | grep -v 'incomplete' | grep -v 'permanent' | grep -v 'Neighbor' | grep $a | awk '{print $1 $2}' >> $CURRENT6
    done
  fi

  comm -2 -3 <(sort -u $CURRENT4) <(sort -u $STATIC4) > $OUT4
  comm -2 -3 <(sort -u $CURRENT6) <(sort -u $STATIC6) > $OUT6
  for i in $(cat /tmp/result_arp_table4.txt)
  do
        logger -p daemon.notice "New IPv4/MAC pair seen: $i"
        echo $i >> $STATIC4
  done
  for i in $(cat /tmp/result_arp_table6.txt)
  do
        logger -p daemon.notice "New IPv6/MAC pair seen $i"
        echo $i >> $STATIC6
  done

  sort -u -o $STATIC4 $STATIC4
  sort -u -o $STATIC6 $STATIC6

  sleep 5
done
