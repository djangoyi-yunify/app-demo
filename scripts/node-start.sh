#!/bin/bash

if [ ! -d "/data/db" ]; then
    mkdir /data/db
fi

/opt/mongodb/bin/mongod --config /opt/mongodb/app/conf/mongo.conf