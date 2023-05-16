#!/bin/bash
#
echo "ATUALIZANDO O SISTEMA"
dnf update -y
dnf upgrade -y
#
echo "INFORMANDO HOSTNAME E IP DO ZABBIX"
#
echo -n "Digite o nome do seu Hostname: "
read hostname
echo -n "Digite o IP ou DNS do zabbix server ou proxy: "
read server
#
clear
echo "INSTALANDO REPOSITÓRIO DO ZABBIX AGENT"
rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/9/x86_64/zabbix-release-6.4-1.el9.noarch.rpm
dnf clean all
dnf install zabbix-agent -y
#
clear
echo "AJUSTANDO ARQUIVO DO ZABBIX"
echo "
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=20
Include=/etc/zabbix/zabbix_agentd.d/
Hostname=$hostname
EnableRemoteCommands=1
LogRemoteCommands=1
Server=$server
ServerActive=$server
# UserParameter=
RefreshActiveChecks=120
ListenPort=10050
StartAgents=10
Timeout=3
DebugLevel=3
" > /etc/zabbix/zabbix_agentd.conf
#
echo "COLOCANDO SERVIÇOS NO BOOT E REINICIANDO"
systemctl start zabbix-agent
systemctl enable zabbix-agent
#
clear
echo "LIBERANDO PORTA NO FIREWALL"
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload 
systemctl restart firewalld
#
clear
echo "FIM " 
echo "CADASTRE IP NO ZABBIX SERVER" 
#
