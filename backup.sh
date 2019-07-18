#!/bin/bash
routers=( 80.241.254.82 213.131.48.46 109.238.235.162 )
backupdir="/home/backup/mikrotik"
privatekey="/root/.ssh/id_dsa"
login="backup"
#passwd="pa$Sw0rd"
fulldir="${backupdir}/`date +%Y`/`date +%m`/`date +%d`"

for r in ${routers[@]}; do
    echo "Making .backup File $r"
    cmd_backup="/system backup save name=${r}.backup"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    echo "Macking .rsc file $r"
    cmd_backup="/export file=${r}"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    sleep 5
    echo "copying from $r"
#    mkdir -p $fulldir
#    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.backup
#    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.rsc
    scp -i $privatekey ${login}@${r}:/${r}.backup ${fulldir}
    scp -i $privatekey ${login}@${r}:/${r}.rsc ${fulldir}
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.backup\""
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.rsc\""
done



#########################
# 1. Create a key using ssh-keygen
# %ssh-keygen -t dsa
# 
# 2. import
# /user ssh-keys private import user=remote private-key-file=mykey public-key-file=mykey.pub passphrase=""
#
#
#############################
