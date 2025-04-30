dssuser=dataiku
dss_version=13.0.3

parent_dir=/home/dataiku
install_dir=$parent_dir/dataiku-dss-$dss_version
data_dir=$parent_dir/dss_data

$install_dir/scripts/install/install-deps.sh -yes -with-r -with-chrome

# Run installer, with data directory $HOME/dss_data and base port 10000
# This fails because of missing system dependencies
sudo -u $dssuser -- $install_dir/installer.sh -d /home/dataiku/dss_data -l /home/dataiku/license.json -p 10000

# Manually start DSS, using the command shown by the installer step
sudo -u $dssuser -- /home/dataiku/dss_data/bin/dss start

# Connect to Dataiku DSS by opening the following URL in a web browser:
#    http://HOSTNAME:10000
# Initial credentials : username = "admin" / password = "admin"

# [Optional] To finalize the installation, restart as a system-managed service:
# Stop the manually-started instance
sudo -u $dssuser -- /home/dataiku/dss_data/bin/dss stop
#
# Create a system service, using the command shown by the previous step
 sudo "/home/dataiku/dataiku-dss-VERSION/scripts/install/install-boot.sh" "/home/dataiku/dss_data" dataiku
#
# Start the system service
 sudo systemctl start dataiku
