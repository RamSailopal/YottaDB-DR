#!/bin/bash
source /home/yotta/yottainit
source /opt/yottadb/current/ydb_env_set
/opt/yottadb/current/mupip set -replication=on -region "*"
/opt/yottadb/current/mupip replicate -instance_create -name=instB -noreplace
/opt/yottadb/current/mupip replicate -source -start -passive -instsecondary=dummy -buffsize=1048576 -log=/root/repl_source.log
/opt/yottadb/current/mupip replicate -receive -start -listenport=4001 -buffsize=1048576 -log=/root/repl_receive.log 
/opt/yottadb/current/mupip replicate -receive -checkhealth
