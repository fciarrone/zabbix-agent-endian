#!/bin/bash

######################################################################
### Script de instalação do Zabbix Agent no Endian 3.3.0 Community ###
######################################################################
### Desenvolvido por Fabio Ciarrone ##################################
######################################################################

mkdir -p /usr/lib/zabbix

chown -R zabbix:zabbix /usr/lib/zabbix

groupadd --system zabbix

useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix

mkdir -p /opt/zabbix-agentd

chmod -R 0755 /opt 

chown -R root:root /opt

curl -L --progress-bar -k -o /opt/zabbix-agentd/zabbix-agent.tar.gz https://www.zabbix.com/downloads/5.0.4/zabbix_agent-5.0.4-linux-3.0-amd64-static.tar.gz 

tar -xzf /opt/zabbix-agentd/zabbix-agent.tar.gz -C /opt/zabbix-agentd/

chown -R root:root /opt/zabbix-agentd

mv /opt/zabbix-agentd/bin/zabbix_get /bin/

mv /opt/zabbix-agentd/bin/zabbix_sender /bin/

mv /opt/zabbix-agentd/sbin/zabbix_agentd /sbin/

mkdir -p /usr/local/etc

chown -R root:root /usr/local/etc

chmod 0755 /usr/local/etc

mv /opt/zabbix-agentd/conf/zabbix_agentd /usr/local/etc/

#Create default conf-file zabbix_agentd

echo "# This is a configuration file for Zabbix agent daemon (Unix)
# To get more information about Zabbix, visit http://www.zabbix.com

############ GENERAL PARAMETERS #################

LogFile=/tmp/zabbix_agentd.log
LogFileSize=1
DebugLevel=3
Server=10.0.0.1
StartAgents=5
ServerActive=10.0.0.1
Hostname=my_hostname

############ ADVANCED PARAMETERS #################

Timeout=30
UnsafeUserParameters=1" > /usr/local/etc/zabbix_agentd.conf


#Creating config files to start zabbix_agentd after boot system

echo "#!/bin/bash

/usr/bin/sudo -u zabbix /bin/bash -c /sbin/zabbix_agentd" > /var/efw/inithooks/rc.firewall.local

chown root:root /var/efw/inithooks/rc.firewall.local

chmod a+x /var/efw/inithooks/rc.firewall.local

echo "#!/bin/bash

/usr/bin/sudo -u zabbix /bin/bash -c /sbin/zabbix_agentd" > /var/efw/inithooks/start.local

chown root:root /var/efw/inithooks/start.local

chmod a+x /var/efw/inithooks/start.local
