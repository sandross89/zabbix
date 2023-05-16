#!/bin/bash
#
echo "ATUALIZANDO O SISTEMA"
dnf update -y
dnf upgrade -y
#
echo "INFORMANDO A SENHA DO BANCO DE DADOS DO ZABBIX"
read -p "Digite a senha do banco de dados:" password
#
echo "INSTALANDO MYSQL E CONFIGURANDO BANCO DE DADOS"
dnf install mariadb-server -y
systemctl start mariadb 
systemctl enable mariadb
echo -e "\nn\ny\ny\ny\ny" | ./usr/bin/mariadb-secure-installation
mysql -uroot -p${password} -e "create database zabbix_proxy character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -p${password} -e "create user zabbix@localhost identified by '${password}';"
mysql -uroot -p${password} -e "grant all privileges on zabbix_proxy.* to zabbix@localhost;"
mysql -uroot -p${password} -e "set global log_bin_trust_function_creators = 1;"
mysql -uroot -p${password} -e "quit;"
#
clear
echo "INSTALANDO REPOSITÓRIO DO ZABBIX PROXY"
rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/9/x86_64/zabbix-release-6.4-1.el9.noarch.rpm
dnf clean all
dnf install zabbix-proxy-mysql zabbix-sql-scripts zabbix-selinux-policy -y
#
echo "CONFIGURANDO BANCO DE DADOS DO ZABBIX"
cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p$password zabbix_proxy
sed -i '130s/^/DBPassword='$password'/' /etc/zabbix/zabbix_proxy.conf
#
clear
echo "COLOCANDO SERVIÇOS NO BOOT E REINICIANDO"
systemctl restart zabbix-proxy
systemctl enable zabbix-proxy
#
clear
echo "FIM"
#
