#!/bin/bash
IP=$1
ADMIN_PW=$2
ROOT_PW=$3

echo "IP: $IP"
echo "Password of admin: $ADMIN_PW"
echo "Set root password: $ROOT_PW"

# Set root password
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "(echo ${ROOT_PW}; echo ${ROOT_PW}) | passwd"

# modify /etc/sshd_config
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "cp /etc/sshd_config /etc/sshd_config.copy"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "cat /etc/sshd_config.copy > /sshd_config.edit"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "sed -i 's/UsePAM yes/UsePAM no/g' /sshd_config.edit"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /sshd_config.edit"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /sshd_config.edit"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "cp /sshd_config.edit /etc/sshd_config"
java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "chmod 600 /etc/sshd_config"

java -jar ./acp_commander.jar -t $IP -ip $IP -pw $ADMIN_PW -c "/etc/init.d/sshd.sh restart"
