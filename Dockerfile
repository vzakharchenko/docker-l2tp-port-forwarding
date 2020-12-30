FROM hwdsl2/ipsec-vpn-server
MAINTAINER Vasyl Zakharchenko <vaszakharchenko@gmail.com>
LABEL author="Vasyl Zakharchenko"
LABEL email="vaszakharchenko@gmail.com"
LABEL name="docker-l2tp-port-forwarding"
ENV SWAN_VER 4.1
ENV DEBIAN_FRONTEND noninteractive
ENV VPN_L2TP_NET "192.168.122.0/24"
ENV VPN_L2TP_POOL "192.168.122.10-192.168.122.254"
ENV VPN_L2TP_LOCAL "192.168.122.1"
RUN apt-get update && apt-get install -y rsyslog iproute2 redir net-tools inetutils-inetd iptables-persistent systemd nodejs
RUN echo "net.ipv4.ip_forward=1">/etc/sysctl.conf
RUN echo "net.ipv4.ip_forward=1">/etc/sysctl.conf
# iptables
COPY ./etc/iptables/rules.v4 /etc/iptables/rules.v4
# rsyslogs
COPY ./etc/rsyslog.conf /etc/rsyslog.conf
COPY ./etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf
# js scripts
COPY l2tp-js/parsingConfigFile.js /opt/parsingConfigFile.js
#RUN chmod 777 /etc/iptables/rules.v4
COPY entrypoint.sh /entrypoint.sh
RUN  chmod +x /entrypoint.sh
ENV CONFIG_PATH  /opt/config.json
ENV SECRET_PATH  /etc/ppp/chap-secrets
ENV ROUTES_UP  /etc/ppp/ip-up.d/routes-up
ENV REDIR_SH  /opt/redir.sh
ENV ENC_PASSWORDS  /opt/enc_passwords.sh
ENV IPSEC_SECRET  /opt/ipsecSecret.sh

ENTRYPOINT ["/entrypoint.sh"]
