#!/bin/bash
#
echo "ATUALIZANDO O SISTEMA"
dnf update -y
dnf upgrade -y
#
echo "INFORMANDO A SENHA DO BANCO DE DADOS DO ZABBIX"
read -s -p "Digite a senha do banco de dados:" password
#
echo "INSTALANDO MYSQL E CONFIGURANDO BANCO DE DADOS"
dnf install mariadb-server -y
systemctl start mariadb 
systemctl enable mariadb
echo -e "\nn\ny\ny\ny\ny" | ./usr/bin/mariadb-secure-installation
mysql -uroot -p${password} -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -p${password} -e "create user zabbix@localhost identified by '${password}';"
mysql -uroot -p${password} -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -uroot -p${password} -e "set global log_bin_trust_function_creators = 1;"
mysql -uroot -p${password} -e "quit;"
#
clear
echo "INSTALANDO REPOSITÓRIO DO ZABBIX SERVER E ZABBIX AGENT"
rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/9/x86_64/zabbix-release-6.4-1.el9.noarch.rpm
dnf clean all
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent -y
#
echo "CONFIGURANDO BANCO DE DADOS DO ZABBIX"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p$password zabbix
sed -i '130s/^/DBPassword='$password'/' /etc/zabbix/zabbix_server.conf
#
clear
echo "COLOCANDO SERVIÇOS NO BOOT E REINICIANDO"
systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm
#
clear
echo "LIBERANDO PORTA NO FIREWALL"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload 
systemctl restart firewalld
#
clear
echo "FIM" 
echo "ACESSE http://IP DO SERVIDOR/ZABBIX"
#
