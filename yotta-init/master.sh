#!/bin/bash
source /home/yotta/yottainit
source /opt/yottadb/current/ydb_env_set
/opt/yottadb/current/mupip set -replication=on -region "*"
/opt/yottadb/current/mupip replicate -instance_create -name=instA
/opt/yottadb/current/mupip replicate -source -start -instsecondary=instB -secondary=instB:4001 -buffsize=1048576 -log=/root/A_B.log
cp /data/yottadb.repl /data/r1.32_x86_64/g
