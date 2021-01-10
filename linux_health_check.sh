#!/bin/bash

# Version: 0.02
# this is a base framework, additional health check commands can be added to extend
# sudo is optional

VIP="$(ip a s public | awk '/inet / {print$2}' |cut -d/ -f 1)"
OUTFILE="health_check"
echo
echo -n "Processing."

rm -f ${OUTFILE}.out 
date >> ${OUTFILE}.out

echo -n "."
(echo; 
echo == OS Version check; 
cat /etc/os-release |grep VERSION |awk -F= '\''{print $2}'\' >> ${OUTFILE}.out

echo -n "."
(echo; 
echo == Kernel Modules Installed check; 
lsmod | egrep -i '\''ses|sg'\' >> ${OUTFILE}.out

echo -n "."
(echo; 
echo == System Uptime; 
uptime | awk -F "," '{print $1}') >> ${OUTFILE}.out

echo -n "."
(echo; 
echo == System Time; 
date) >> ${OUTFILE}.out

(echo; 
echo == Free memory; 
for i in $(cat $1);
do
    echo -n "@ Node : ";echo $i 
    ssh $i 'free |head -3' 
done) >> ${OUTFILE}.out

(echo; 
echo == Memory Stat; 
for i in $(cat $1);
do
    echo -n "@ Node : ";echo $i 
    ssh $i 'cat /proc/meminfo |head -12 |grep -v SwapCached' 
done) >> ${OUTFILE}.out

(echo; 
echo == Top 10 CPU consuming process; 
for i in $(cat $1);
do
    echo -n "@ Node : ";echo $i 
    ssh $i 'ps aux | sort -rk 3 | head -n 11' | awk '{print $2 "\t" $3 "\t" $11}' 
done) >> ${OUTFILE}.out

(echo; 
echo == Top 10 Memory consuming process;  
for i in $(cat $1);
do
    echo -n "@ Node : ";echo $i 
    ssh $i 'ps aux | sort -rk 4 | head -n 11' | awk '{print $2 "\t" $4 "\t" $5 "\t" $6 "\t" $11}' 
done) >> ${OUTFILE}.out

(echo;
echo "End of health check") >> ${OUTFILE}.out 
echo "done"
cp ${OUTFILE}.out ${OUTFILE}.out.`date +"%Y-%m-%d_%H:%M:%S"`

printf "%b" "End of health check! Read ${OUTFILE}.out file for the result.\n"