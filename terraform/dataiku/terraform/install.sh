#!/bin/bash
set -e

# Custom Dataiku installation documentation: 
#  https://doc.dataiku.com/dss/latest/installation/custom/index.html

# Script assumptions:
#  - Executed as root
#  - OS: RHEL 8.4 and later 8.x (RHEL 9.x requires a different cgroups setup)
#  - System resources: minimum of 32 GB RAM
#  - Filesystem: XFS or ext4
#  - Installation port (and 10 consecurive ports) are usable by Dataiku
#  - codeready-builder-for-rhel-8 yum repository is enabled
#  - ssl certificates present, could be self-signed: https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl

# 0) Script variables
dssuser=dataiku
dss_version=13.0.3
install_port=14000
installation_type="design" # can be "automation" or "design"

ulimit_min=65536
dataiku_systemd_service=fhb
allowed_user_groups=dss_users

parent_dir=/data/dataiku
install_dir=$parent_dir/dataiku-dss-$dss_version
data_dir=$parent_dir/dss_data

postgres_parent_dir=/data/pgsql
postgres_port=5431

dss_public_host=ec2-54-191-155-39.us-west-2.compute.amazonaws.com
ssl_cert_path=/home/ec2-user/ssl/mysite.crt
ssl_key_path=/home/ec2-user/ssl/mysite.key
root_ca_path=/home/ec2-user/my-ca/certs/rootCA.cert.pem

# 1) Pre-installation tasks
#  - Stop dataiku (in case this script is not being run for the first time)
#  - create $dssuser (i.e. the Linux user under which Dataiku is installed) (if user not created)
#  - create data directory and install directory parent, assign appropriate permissions
#  - ulimits: set max number of open files (-Hn) and running processes (-Hu) are at least $ulimit_min (if ulimits not already applied) 

if systemctl list-unit-files | awk '{print $1}' | grep "^dataiku.$dataiku_systemd_service.service$" >/dev/null; then
    echo "Stopping Dataiku..."
    systemctl stop dataiku.$dataiku_systemd_service
fi

if ! id $dssuser 2>/dev/null; then
  useradd $dssuser
fi

mkdir -p $parent_dir
chown $dssuser:$dssuser $parent_dir
chmod 755 $parent_dir

ulimit_hn="$dssuser      hard    nproc           $(sudo -u $dssuser -- ulimit -Hn)"
ulimit_hu="$dssuser      hard    nofile          $(sudo -u $dssuser -- ulimit -Hu)"

grep -qxF "$ulimit_hn" /etc/security/limits.conf || echo "$ulimit_hn" >> /etc/security/limits.conf
grep -qxF "$ulimit_hu" /etc/security/limits.conf || echo "$ulimit_hu" >> /etc/security/limits.conf

# 2) Dataiku Design node installation 
#  - Download and unpack dataiku tarballs (if not already downloaded)
#  - Unpack dataiku tarball
#  - Install dependencies for Dataiku installation (including R and graphics export)
#  - Backup data directory (if it exists)
#  - Install dataiku (if not already installed)

yum install -y wget

if [ ! -f $parent_dir/dataiku-dss-$dss_version.tar.gz ]; then
    sudo -u $dssuser -- wget -P $parent_dir "https://cdn.downloads.dataiku.com/public/dss/$dss_version/dataiku-dss-$dss_version.tar.gz"
    sudo -u $dssuser -- tar -C $parent_dir -xzf $parent_dir/dataiku-dss-$dss_version.tar.gz
fi

$install_dir/scripts/install/install-deps.sh -yes -with-r -with-chrome

if [ ! -f $data_dir/dss-version.json ]; then
    echo "Installing DSS..."
    sudo -u $dssuser -- $install_dir/installer.sh -d $data_dir -p $install_port -t $installation_type
else
    echo "Backing up data directory prior to installation..."
    sudo -u $dssuser -- tar czf $parent_dir/data_dir_backup_$(date +%s).tar.gz $data_dir

    echo "Upgrading DSS..."
    sudo -u $dssuser -- $install_dir/installer.sh -d $data_dir -u
fi

# 3) Dataiku post-installation tasks:
#  - Start on boot (systemctl)
#  - R integration
#  - Graphics export
#  - Hadoop and Spark integration (+ download tarballs)

$install_dir/scripts/install/install-boot.sh -n $dataiku_systemd_service $data_dir $dssuser

# sudo -i -u $dssuser -- $data_dir/bin/dssadmin install-R-integration
sudo -u $dssuser -- $data_dir/bin/dssadmin install-graphics-export

if [ ! -f $parent_dir/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-$dss_version.tar.gz ]; then
    sudo -u $dssuser -- wget -P $parent_dir "https://cdn.downloads.dataiku.com/public/dss/$dss_version/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-$dss_version.tar.gz"
fi

if [ ! -f $parent_dir/dataiku-dss-spark-standalone-$dss_version-3.4.1-generic-hadoop3.tar.gz ]; then
    sudo -u $dssuser -- wget -P $parent_dir "https://cdn.downloads.dataiku.com/public/dss/$dss_version/dataiku-dss-spark-standalone-$dss_version-3.4.1-generic-hadoop3.tar.gz"
fi

sudo -u $dssuser -- $data_dir/bin/dssadmin install-hadoop-integration -standaloneArchive $parent_dir/dataiku-dss-hadoop-standalone-libs-generic-hadoop3-$dss_version.tar.gz
sudo -u $dssuser -- $data_dir/bin/dssadmin install-spark-integration -standaloneArchive $parent_dir/dataiku-dss-spark-standalone-$dss_version-3.4.1-generic-hadoop3.tar.gz -forK8S 

# 4) User isolation framework
#  https://doc.dataiku.com/dss/latest/user-isolation/index.html
#  - Enable UIF
#  - Configure security-config.ini (see docs and notes below)
#  - Create the $allowed_user_groups

#  Notes:
#   - This UIF automatically creates linux users mapped from Dataiku users
#   - All Linux users are members of a Linux group $allowed_user_groups

$data_dir/bin/dssadmin install-impersonation $dssuser

installid=$(awk -F "= " '/installid/ {print $2}' $data_dir/install.ini)
mv -n -f /etc/dataiku-security/$installid/security-config.ini /etc/dataiku-security/$installid/security-config.ini.bak

cat <<EOF > /etc/dataiku-security/$installid/security-config.ini
[users]
# Enter here the list of groups that are allowed to execute commands.
# DSS may impersonate all users belonging to one of these groups
#
# Specify this as a semicolon;separated;list
#
# This must double-check with the settings of the groups with
# code-writing or Hadoop/Spark privileges in DSS
allowed_user_groups = $allowed_user_groups
auto_create_users = yes
auto_created_users_prefix = dssuser_
auto_created_users_group = $allowed_user_groups

[dirs]
# Absolute path to DSS data dir.
dss_datadir = $data_dir

# Additional 'allowed' folders. File operations are allowed in
# the dss datadir and these folders. Use this if you use symlinks for jobs/
# or any other DSS folder
#
# Specify this as a semicolon;separated;list
additional_allowed_file_dirs =/sys/fs/cgroup/cpu/dataiku;/sys/fs/cgroup/memory/dataiku
EOF

chmod 600 /etc/dataiku-security/$installid/security-config.ini

if ! getent group $allowed_user_groups >/dev/null; then 
    groupadd $allowed_user_groups; 
fi

# 5) Cgroups protection
#  https://doc.dataiku.com/dss/latest/operations/cgroups.html#creating-dss-specific-cgroups-at-boot-time
#  - Create cgroup directories for memory and CPU
#  - Setup auto-creation of cgroup directories on boot (cgroups v1) (only add the line if it does not already exist)

mkdir -p /sys/fs/cgroup/memory/dataiku
chown -Rh $dssuser /sys/fs/cgroup/memory/dataiku

mkdir -p /sys/fs/cgroup/cpu/dataiku
chown -Rh $dssuser /sys/fs/cgroup/cpu/dataiku

sed -i 's@^.*DSS_CGROUPS=.*$@DSS_CGROUPS="memory/dataiku:cpu/dataiku"@g' "/etc/dataiku/$installid/dataiku-boot.conf"

# 6) Add nginx reverse proxy on HTTPS
#  Docs: https://doc.dataiku.com/dss/latest/installation/custom/reverse-proxy.html#https-deployment-behind-a-nginx-reverse-proxy
#  Also add the certificate to the system trust store, as in the case of FHB their cert is signed by their internal CA (which signs a lot of other apps, e.g. artifactory).

# Note: selinux is set to permissive mode, as the default selinux policies block nginx from redirecting traffic.
#       An alternative to this would be to modify the selinux policies.

setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=permissive/g' "/etc/selinux/config"

cat << EOF > /etc/nginx/conf.d/dataiku.conf
server {
    # Host/port on which to expose Data Science Studio to users
    listen 443 ssl;
    server_name $dss_public_host;
    ssl_certificate $ssl_cert_path;
    ssl_certificate_key $ssl_key_path;
    location / {
        # Base url of the Data Science Studio installation
        proxy_pass http://localhost:$install_port/;
        proxy_redirect http://\$proxy_host https://\$host;
        proxy_redirect http://\$host https://\$host;
        # Allow long queries
        proxy_read_timeout 3600;
        proxy_send_timeout 600;
        # Allow large uploads
        client_max_body_size 0;
        # Allow large downloads
        proxy_max_temp_file_size 0;
        # Allow protocol upgrade to websocket
        proxy_http_version 1.1;
        proxy_set_header Host \$http_host;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

systemctl daemon-reload
systemctl enable nginx
systemctl restart nginx

yum install -y ca-certificates
rm -f /etc/pki/ca-trust/source/anchors/localCA.crt
cp $root_ca_path /etc/pki/ca-trust/source/anchors/localCA.crt
update-ca-trust extract

# 7) External postgres runtime database
#  Docs: https://doc.dataiku.com/dss/latest/operations/runtime-databases.html

#  - Install posgtres 12+, see: https://www.postgresql.org/download/linux/redhat/
#  - Create data directory (on same volume as dataiku data dir)
#  - Modify a handful of configuration settings required to work as a Dataiku runtime database
#  - Create a user and database (of not already created)
#  - Configure Dataiku to use the runtime database

dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf -qy module disable postgresql
dnf install -y postgresql16-server

mkdir -p $postgres_parent_dir
chown postgres:postgres $postgres_parent_dir

if [ ! -f $postgres_parent_dir/data/pg_hba.conf ]; then
    sudo -u postgres /usr/pgsql-16/bin/initdb -D $postgres_parent_dir/data
fi

mv -n -f $postgres_parent_dir/data/pg_hba.conf $postgres_parent_dir/data/pg_hba.conf.bak
cat <<EOF > $postgres_parent_dir/data/pg_hba.conf
 # Database administrative login by Unix domain socket
local all postgres peer

# TYPE DATABASE USER ADDRESS METHOD  
# "local" is for Unix domain socket connections only
local all all peer

# IPv4 local connections:
host all all 127.0.0.1/32 md5

# IPv6 local connections:
host all all ::1/128 md5

# Allow replication connections from localhost, by a user with the
# replication privilege.
local replication all peer
host replication all 127.0.0.1/32 md5
host replication all ::1/128 md5
EOF

sed -i 's/^.*max_connections =.*$/max_connections = 500/g' "$postgres_parent_dir/data/postgresql.conf"
sed -i 's/^.*shared_buffers =.*$/shared_buffers = 512MB/g' "$postgres_parent_dir/data/postgresql.conf"
sed -i 's/^.*port =.*$/port = '$postgres_port'/g' "$postgres_parent_dir/data/postgresql.conf"

mkdir -p /etc/systemd/system/postgresql-16.service.d
cat <<EOF > /etc/systemd/system/postgresql-16.service.d/override.conf
[Service]
Environment=PGDATA=$postgres_parent_dir/data
EOF

systemctl daemon-reload
systemctl enable postgresql-16
systemctl start postgresql-16

if ! sudo -u postgres psql -p $postgres_port -tXAc "SELECT * FROM pg_roles;" | grep -qw dssruntimedbuser; then    
    sudo -u postgres -- psql -p $postgres_port -c "CREATE USER dssruntimedbuser WITH PASSWORD 'runtimedbpassword123!';"
fi

if ! sudo -u postgres psql -p $postgres_port -lqt | cut -d \| -f 1 | grep -qw dssruntimedb; then
    sudo -u postgres -- psql -p $postgres_port -c "CREATE DATABASE dssruntimedb OWNER dssruntimedbuser LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';"
fi

encrypted_postgres_password=$(sudo -u $dssuser -- $data_dir/bin/dssadmin encrypt-password runtimedbpassword123!)
echo $encrypted_postgres_password

yum install -y jq

jq --arg password $encrypted_postgres_password --arg port $postgres_port '.internalDatabase =  {
    "connection": {
        "params": {
            "port": $port|tonumber,
            "host": "localhost",
            "user": "dssruntimedbuser",
            "password": "\($password)",
            "db": "dssruntimedb"
        },
        "type": "PostgreSQL"
    },
    "externalConnectionsMaxIdleTimeMS": 600000,
    "externalConnectionsValidationIntervalMS": 180000,
    "maxPooledExternalConnections": 50,
    "builtinConnectionsMaxIdleTimeMS": 1800000,
    "builtinConnectionsValidationIntervalMS": 600000,
    "maxPooledBuiltinConnectionsPerDatabase": 50
}' $data_dir/config/general-settings.json > $data_dir/config/general-settings.json.tmp

rm -f $data_dir/config/general-settings.json 
cp $data_dir/config/general-settings.json.tmp $data_dir/config/general-settings.json
chown $dssuser:$dssuser $data_dir/config/general-settings.json

# 7) Start dataiku
echo "Starting Dataiku..."
systemctl start dataiku.$dataiku_systemd_service
