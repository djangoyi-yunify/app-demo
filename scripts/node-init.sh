#!/bin/bash

# Get rsname,port,mysid,nodelist
# rsname=rs0
# port=27017
# mysid=3
# nodelist=('1|192.168.1.1' '2|192.168.1.2' '3|192.168.1.3' )
# source test.info
source /opt/mongodb/app/conf/replica.info

function getsid() {
    echo `echo $1 | cut -d'|' -f1`
}

function getip() {
    echo `echo $1 | cut -d'|' -f2`
}

sid=`getsid ${nodelist[0]}`
if [ "$mysid" != "$sid" ];then
    exit 0
fi

memberstr=''
if [ "${#nodelist[@]}" -eq 1 ]; then
    memberstr="{_id:0,host:\"$(getip ${nodelist[0]})\"}"
else
    for ((i=0; i<${#nodelist[@]}; i++)); do
        if [ "$i" -eq 0 ]; then
            memberstr="{_id:$i,host:\"$(getip ${nodelist[i]})\"}"
        else
            memberstr="$memberstr,{_id:$i,host:\"$(getip ${nodelist[i]})\"}"
        fi
    done
fi

initjs=$(cat <<EOF
rs.initiate({
    _id:"$rsname",
    members:[$memberstr]
})
EOF
)

# do replica set init
/opt/mongodb/bin/mongo --eval "$initjs"
