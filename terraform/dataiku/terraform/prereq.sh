dssuser=dataiku
dss_version=13.0.3

parent_dir=/home/dataiku
install_dir=$parent_dir/dataiku-dss-$dss_version
data_dir=$parent_dir/dss_data

if ! id $dssuser 2>/dev/null; then
  sudo useradd $dssuser
fi


mkdir -p $parent_dir
sudo chown $dssuser:$dssuser $parent_dir
sudo chmod 755 $parent_dir


sudo -u $dssuser -- wget -P $parent_dir "https://cdn.downloads.dataiku.com/public/dss/$dss_version/dataiku-dss-$dss_version.tar.gz"
sudo -u $dssuser -- tar -C $parent_dir -xzf $parent_dir/dataiku-dss-$dss_version.tar.gz
