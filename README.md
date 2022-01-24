# YottaDB-DR

This repository demonstrates disaster recovery with YottaDB using docker containers. The same process applies to GTm.

Further more indepth details regarding replication and disaster recovery can be found from the official YottaDB documentation:

https://docs.yottadb.com/AdminOpsGuide/dbrepl.html

# Process

NOTE - A number a terminal windows or tmux panel will be required for this exercise.

Clone the this repo:

    git clone https://github.com/RamSailopal/YottaDB-DR.git
    
    cd YottaDB-DR
    
Create a docker network called yotta-dr in order for separate containers to resolve each others IP addresses via hostname:    

    docker network create yotta-dr
    
Create an (master) docker container called instA using the yottaDB image:
    
    docker run --name instA --hostname instA --rm -v $PWD/yotta-init:/home/yotta -it docker.io/yottadb/yottadb-base /bin/bash
    
In another terminal, add the container to the docker network we created:    
    
    docker network connect yotta-dr instA
    
In a further terminal, create another (replicating) docker container called instB using the yottaDB image:

    docker run --name instB --hostname instB --rm -v $PWD/yotta-init:/home/yotta -it docker.io/yottadb/yottadb-base /bin/bash
    
Add this terminal to the network as before:

    docker network connect yotta-dr instB
    
In the instA container terminal, run /home/yottainit/master.sh

This will set the instance up for replication and then begin to send replication information to instB. The master.sh script is as follows:

    mupip set -replication=on -region "*"
    mupip replicate -instance_create -name=instA
    mupip replicate -source -start -instsecondary=instB -secondary=172.17.0.2:4001 -buffsize=1048576 -log=/root/A_B.log
    
In the instB container terminal, run /home/yottainit/slave.sh

This will set the instance up for replication and then begin to receive replication information to instA. The slave.sh script is as follows:
    
    mupip set -replication=on -region "*"
    mupip replicate -instance_create -name=instB -noreplace
    
    # Now create a local journal pool for the logs
    
    mupip replicate -source -start -passive -instsecondary=dummy -buffsize=1048576 -log=/root/repl_source.log
    mupip replicate -receive -start -listenport=4001 -buffsize=1048576 -log=/root/repl_receive.log 
    mupip replicate -receive -checkhealth
    
In instA container terminal, run:

    /opt/yottadb/current/ydb
    S ^TEST(1)=1
    
In InstB container terminal, run:
    
    /opt/yottadb/current/ydb
    D ^%G
    TEST
    
 You should see the global set of TEST in InstA being replicated in InstB
    
