#!/usr/bin/env bash
set -e

sudo mkdir -p /etc/dpkg/dpkg.cfg.d
sudo tee /etc/dpkg/dpkg.cfg.d/01_nodoc << EOF
path-exclude /usr/share/doc/*
path-include /usr/share/doc/*/copyright
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF


export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"
sudo apt-get clean ${APTARGS}
sudo apt-get update ${APTARGS}

sudo apt-get upgrade -y ${APTARGS}
sudo apt-get dist-upgrade -y ${APTARGS}

which unzip socat jq dnsutils net-tools vim curl sshpass &>/dev/null || {
sudo apt-get update -y ${APTARGS}
sudo apt-get install unzip socat jq dnsutils net-tools vim curl sshpass -y ${APTARGS}
}

# install consul
mkdir -p /tmp/pkg/
if [ -z "$CONSUL_VER" ]; then
    CONSUL_VER=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)
fi
response=$(curl -LI https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip -o /tmp/pkg/consul_${CONSUL_VER}_linux_amd64.zip -w '%{http_code}\n' -s)

if [ $response == 200 ]; then
    curl -s https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip -o /tmp/pkg/consul_${CONSUL_VER}_linux_amd64.zip
else
   exit 1
fi



echo "Installing Consul version ${CONSUL_VER} ..."
pushd /tmp
unzip /tmp/pkg/consul_${CONSUL_VER}_linux_amd64.zip 
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul