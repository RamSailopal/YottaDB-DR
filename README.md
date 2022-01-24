# YottaDB-DR

This repository demonstrates disaster recovery with YottaDB using docker containers. The same process applies to GTm.

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
    

    
