docker run -dit --name my-ubuntu-ssh-2 -p 2225:22 ubuntu:22.04

docker exec -it my-ubuntu-ssh-2 bash

apt update && apt install -y openssh-server
mkdir -p /var/run/sshd
service ssh start
useradd -m -s /bin/bash ubuntu && echo "ubuntu:password" | chpasswd
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh


cat <<EOF > /home/ubuntu/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDArCqS9QWsOYG+CpQD/tXk0mGwUs1yVEOaCC+CRyyU6uoZ3BDv5jscCtRczc4gczNpuSt3tmajxqgA4xG7pDPTXR3vpGjBf8E8UWB1VgPOugNhcMcZ2RWkZm3jsbmAilmXpHJSzn2hA+5Lu7WYEHccViqTAMH/JEv86NU+7bqABYtG8/70UrFvCz8vco4vlEyW6mvqEZcUTxHwGHXLF4dOZgOn3h5ZBJ9oCMynX/I8yZGK0gj5EmOJzscKoqTSTdpGKXVi7FiKzYUoN7L18FwqUX92EpzbqyvRrlnldRvZAg2t04P8ZktHL8kApF+5lyRd8Dlj/WPJ7/qzgSVtrKy3 ssh-key-2022-12-06
EOF


chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

sed -i 's/^#\?\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config && sed -i 's/^#\?\(PasswordAuthentication\).*/\1 no/' /etc/ssh/sshd_config && sed -i 's/^#\?\(PermitRootLogin\).*/\1 no/' /etc/ssh/sshd_config

service ssh start
