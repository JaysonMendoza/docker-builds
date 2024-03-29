#!/bin/bash
# A simple startup script for dockerfile. This will start sshd
# before it runs the normal container startup
# We use this because containers can only execute one command on startup
declare -r SSHD_EXEC="/usr/sbin/sshd"
declare -r START_SSHD=${START_SSHD:true}
declare -r DEFAULT_LINUX_USER="oracle"
declare -r README_FILE="/home/$DEFAULT_LINUX_USER/README.TXT"
echo "===================CONTAINER START SCRIPT============================="
echo "Completing startup tasks then  running Oracle DBMS...."
#Setup readme file
echo "This file contains important details for the container user" | tee $README_FILE


echo "Starting SSHD, disable with environment variable START_SSHD=false"
if [ -f "$SSHD_EXEC" ]; then
    echo "Starting $SSHD_EXEC ..."  
    su - root -c $SSHD_EXEC
    if [ $? -eq 0 ]; then
        printf "Started %s\n" $SSHD_EXEC
        echo  "SSH DETAILS" | tee -a $README_FILE
        echo "You may connect to localhost using the port assigned by docker which maps to port 22 in the container"  | tee -a $README_FILE
        echo "Connection Example: ssh -p <yourPort> $DEFAULT_LINUX_USER@localhost"  | tee -a $README_FILE
        echo "Default Username: $DEFAULT_LINUX_USER, Password: $ORACLE_PWD" | tee -a $README_FILE
    else
        echo "[ERROR] Cannot failed to start $SSHD_EXEC" >&2
    fi
else
   echo "[ERROR] Cannot find file $SSHD_EXEC. Is sshd installed?" >&2
fi

echo "Oracle DBMS Connection Details: SID=$ORACLE_SID, USER=$DEFAULT_ORACLE_DB_USER, PASSWORD=$ORACLE_PWD" | tee -a $README_FILE
echo "[WARN] If you changed the password using $PWD_FILE this may not be accurate!" | tee -a $README_FILE

echo "starting DBMS with $ORACLE_BASE/$RUN_FILE"
echo "Important details saved to ~/README.TXT\n"

echo "===================$ORACLE_BASE/$RUN_FILE SCRIPT============================="
$ORACLE_BASE/$RUN_FILE #This file should not stop running until container shutdown and keep the container ruinning