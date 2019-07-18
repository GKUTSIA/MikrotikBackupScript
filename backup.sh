#!/bin/bash
routers=( xxx.xxx.xxx.xxx yyy.yyyy.yyyy.yyy zzz.zzz.zzz.zzz) #Type as many as you wish
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
