#!/bin/bash -e

# if you need a proxy set them here:
# export http_proxy=http://myproxy.example.com:80
# export https_proxy=http://myproxy.example.com:80

set -x
cwd=$PWD
build_dir=/tmp/build/
mkdir $build_dir
cd $build_dir
wget --no-check-certificate https://collectd.org/files/collectd-5.4.1.tar.gz
tar zxf collectd-5.4.1.tar.gz 

sudo apt-get install build-essential  
mkdir /tmp/collectd
sudo apt-get -y install libcurl3 librrd2-dev libsnmp-dev
cd cd collectd-5.4.1
 ./configure --prefix=/tmp/collectd 
make install

tar zcf /tmp/collectd.tgz ./*
cd $cwd
mkdir bins
cd bins
mv /tmp/collectd.tgz .

#wget  --no-check-certificate  https://raw.githubusercontent.com/dwm/collectd-ceph/master/collectd-ceph.py

wget  --no-check-certificate  https://raw.githubusercontent.com/mleinart/collectd-haproxy/master/haproxy.py

#
# Get collectd-ceph
#
cd /tmp/
wget  --no-check-certificate https://github.com/rochaporto/collectd-ceph/archive/master.zip
unzip master
rm master.zip
cd collectd-ceph-master
mv plugins ceph
tar zcf ../collectd-ceph.tgz ./ceph
cd ../
cd $cwd/bins
mv /tmp/collectd-ceph.tgz  .

#
# Get collectd-openstack
#

cd /tmp
wget  --no-check-certificate https://github.com/rochaporto/collectd-openstack/archive/master.zip
unzip master
rm master.zip
cd collectd-openstack-master
mv plugins openstack
tar zcf ../collectd-openstack.tgz ./openstack
cd ../
cd $cwd/bins
mv /tmp/collectd-openstack.tgz  .
