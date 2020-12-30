#!/bin/sh

set -e
service rsyslog start
iptables-restore < /etc/iptables/rules.v4

# service pptpd restart
# /opt/redir.sh
sed -i '$ d' /opt/src/run.sh
sed -i '/IPsec PSK:/d' /opt/src/run.sh
sed -i '/Username:/d' /opt/src/run.sh
sed -i '/Password:/d' /opt/src/run.sh
/opt/src/run.sh
#sed -i '/refuse pap = yes/d' /etc/xl2tpd/xl2tpd.conf
node /opt/parsingConfigFile.js
#echo "mschap-v2" >> /etc/ppp/options.xl2tpd
#echo "pap" >> /etc/ppp/options.xl2tpd
chmod +x /opt/redir.sh
chmod +x /opt/enc_passwords.sh
chmod +x /opt/ipsecSecret.sh
chmod +x /etc/ppp/ip-up.d/routes-up
/opt/enc_passwords.sh
/opt/ipsecSecret.sh
service ipsec restart
service xl2tpd start
/opt/redir.sh
tail -f /var/log/messages

