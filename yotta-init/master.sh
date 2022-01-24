#!/bin/bash
source yottainit
/opt/yottadb/current/mupip replicate -source -start -passive -instsecondary=dummy -buffsize=1048576 -log=/root/repl_source.log
/opt/yottadb/current/mupip replicate -receive -start -listenport=4001 -buffsize=1048576 -log=/root/repl_receive.log 
/opt/yottadb/current/mupip replicate -source -checkhealth
