
include_recipe "bcpc-monitoring::collectd"

#
# Set up haproxy monitoring 
#

template "/usr/local/etc/collectd.d/haproxy.conf" do
  source "collectd.haproxy.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[collectd]", :delayed
end

cookbook_file "/usr/local/lib/collectd/python-modules/haproxy.py" do
  source "bins/haproxy.py"
  owner "root"
  mode 00744
  notifies :restart, "service[collectd]", :delayed
end



