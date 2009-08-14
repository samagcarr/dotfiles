#!/bin/bash
#
# requires bc for decimal math
#
###

lynx -dump http://bbs.archlinux.org/profile.php?id=$1 | grep -A1 "Registered\|Posts" > /tmp/numbers.$$

N=$(grep -A1 Posts /tmp/numbers.$$ | tail -n1 | awk '{print $1}')
R=$(grep -A1 Registered /tmp/numbers.$$ | tail -n1 | awk '{print $1}')

R=$(date -d $R +%s)
T=$(date +%s)

echo "scale=10; $N / (($T - $R) / 86400)" | bc

rm /tmp/numbers.$$