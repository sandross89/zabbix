### EXECUTE OS SEGUINTES COMANDOS

### BAIXAR ARQUIVOS DE INSTALAÇÃO

### ZABBIX SERVER
wget https://raw.githubusercontent.com/sandross89/zabbix/main/zabbix-server.sh

### ZABBIX PROXY
wget https://raw.githubusercontent.com/sandross89/zabbix/main/zabbix-proxy.sh

### ZABBIX AGENT
wget https://raw.githubusercontent.com/sandross89/zabbix/main/zabbix-agent.sh

### COLOCANDO PERMISSÃO DE EXECUÇÃO
chmod +x ./zabbix-server.sh

chmod +x ./zabbix-proxy.sh

chmod +x ./zabbix-agent.sh

### EXECUTAR ARQUIVO
./zabbix-server.sh

./zabbix-proxy.sh

./zabbix-agent.sh
