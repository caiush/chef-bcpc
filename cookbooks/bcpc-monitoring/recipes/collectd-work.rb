
include_recipe "bcpc-monitoring::collectd"

#
# Set up ceph monitoring 
#
template "/usr/local/etc/collectd.d/ceph.conf" do
  source "collectd.ceph.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[collectd]", :delayed
end

cookbook_file "/usr/local/lib/collectd/python-modules/collectd-ceph.py" do
  source "bins/collectd-ceph.py"
  owner "root"
  mode 00744
end

