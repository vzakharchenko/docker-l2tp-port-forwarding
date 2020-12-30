# Docker image with L2TP server including routing and port forwarding

## Description
Access private network from the internet, support port forwarding from private network to outside via cloud.

[The same solution with PPTP Server](https://github.com/vzakharchenko/docker-pptp-port-forwarding)

[GitHub Project](https://github.com/vzakharchenko/docker-l2tp-port-forwarding)
## Installation :
[create /opt/config.json](#configjson-structure)
```
curl -sSL https://raw.githubusercontent.com/vzakharchenko/docker-l2tp-port-forwarding/main/ubuntu.install| bash
```
or
```
export CONFIG_PATH=/opt/config.json
curl -sSL https://raw.githubusercontent.com/vzakharchenko/docker-l2tp-port-forwarding/main/l2tp-js/generateDockerCommands.js -o generateDockerCommands.js
`node generateDockerCommands.js`
```


## Features
 - Docker image
 - [Management routing  and portforwarding using json file](#configjson-structure)
 - [Connect to LAN from the internet](#connect-to-lan-from-the--internet)
 - [Port forwarding through VPN (L2TP with IPSec)](#port-forwarding)
 - [Connect multiple networks](#connect-multiple-networks)
 - [Automatic installation(Ubuntu)](#automatic-cloud-installation)
 - [Manual Installation steps (Ubuntu)](#manual-cloud-installationubuntu)

## config.json structure

```
{
  "users": {
    "USER_NAME": {
      "password": "PASSWORD",
      "ip": "192.168.122.XX",
      "forwarding": [{
        "sourceIp": "APPLICATION_IP",
        "sourcePort": "APPLICATION_PORT",
        "destinationPort": REMOTE_PORT
      }],
      "routing": [
        {
          "route": "ROUTING_TABLE"
        }
      ]
    }
  },
  "ipsec": {
        "secret":"IPSEC_SHARED_SECRET"
  }
}
```
Where
- **USER_NAME** username or email
- **PASSWORD** user password
- **192.168.122.XX** uniq ip from range 192.168.122.10-192.168.122.254
- **APPLICATION_IP** service IP behind NAT (port forwarding)
- **APPLICATION_PORT** service PORT behind NAT (port forwarding)
- **REMOTE_PORT**  port accessible from the internet (port forwarding)
- **REMOTE_PORT**  port accessible from the internet (port forwarding)
- **ROUTING_TABLE**  ip with subnet for example 192.168.8.0/24
- **IPSEC_SHARED_SECRET**  Ipsec shared secret

## Examples

### Connect to LAN from the  internet
![](https://github.com/vzakharchenko/docker-l2tp-port-forwarding/blob/main/img/l2tpRouting.png?raw=true)
**user1** - router with subnet 192.168.88.0/24 behind NAT
**user2** - user who has access to subnet 192.168.88.0/24 from the Internet
```
{
  "users": {
    "user1": {
      "password": "password1",
      "ip": "192.168.122.10",
      "routing": [
        {
          "route": "192.168.88.0/24"
        }
      ]
    },
    "user2": {
      "password": "password2",
      "ip": "192.168.122.11"
    }
  },
  "ipsec": {
    "secret":"01234567890"
  }
}
```

### Port forwarding
![](https://github.com/vzakharchenko/docker-l2tp-port-forwarding/blob/main/img/l2tpWithRouting.png?raw=true)
**user** - router with subnet 192.168.88.0/24 behind NAT.
Subnet contains service http://192.168.8.254:80 which is available at from http://195.138.164.211:9000

```
{
  "users": {
    "user": {
      "password": "password",
      "ip": "192.168.122.10",
      "forwarding": [{
        "sourceIp": "192.168.88.1",
        "sourcePort": "80",
        "destinationPort": 9000
      }],
    }
  },
  "ipsec": {
    "secret":"01234567890"
  }
}
```
### connect multiple networks
![](https://github.com/vzakharchenko/docker-l2tp-port-forwarding/blob/main/img/l2tpWithRouting2.png?raw=true)
**user1** - router with subnet 192.168.88.0/24 behind NAT. Subnet contains service http://192.168.88.254:80 which is available at from http://195.138.164.211:9000
**user2** - router with subnet 192.168.89.0/24 behind NAT.
**user3** - user who has access to subnets 192.168.88.0/24 and 192.168.89.0/24 from the Internet
```
{
  "users": {
    "user1": {
      "password": "password1",
      "ip": "192.168.122.10",
      "forwarding": [
        {
          "sourceIp": "192.168.88.254",
          "sourcePort": "80",
          "destinationPort": 9000
        }
      ],
       "routing": [
        {
          "route": "192.168.88.0/24"
        }
      ]
    },
    "user2": {
      "password": "password2",
      "ip": "192.168.122.11",
      "routing": [
        {
          "route": "192.168.89.0/24"
        }
      ]
    },
    "user3": {
      "password": "password3",
      "ip": "192.168.122.12"
    }
  },
  "ipsec": {
      "secret":"01234567890"
  }
}
```


## Troubleshooting
1. Viewing logs in docker container:
```
docker logs l2tp-port-forwarding -f
```
2. print routing table
```
docker exec l2tp-port-forwarding bash -c "ip route"
```
3. print iptable rules
```
docker exec l2tp-port-forwarding bash -c "iptables -S"
```


## Cloud Installation
### Automatic cloud installation
[create /opt/config.json](#configjson-structure)
```
curl -sSL https://raw.githubusercontent.com/vzakharchenko/docker-l2tp-port-forwarding/main/ubuntu.install| bash
```

### Manual Cloud Installation(Ubuntu)

1. install all dependencies
```
sudo apt-get update && sudo apt-get install -y iptables git iptables-persistent node
```
2. install docker
```
sudo apt-get remove docker docker.io containerd runc
sudo curl -sSL https://get.docker.com | bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

3. Configure host machine
```
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.netfilter.nf_conntrack_helper=1
sudo echo "net.ipv4.ip_forward=1">/etc/sysctl.conf
sudo echo "net.netfilter.nf_conntrack_helper=1">/etc/sysctl.conf
```
4. [create /opt/config.json](#configjson-structure)

5. start docker image

```
export CONFIG_PATH=/opt/config.json
curl -sSL https://raw.githubusercontent.com/vzakharchenko/docker-l2tp-port-forwarding/main/l2tp-js/generateDockerCommands.js -o generateDockerCommands.js
`node generateDockerCommands.js`
```
