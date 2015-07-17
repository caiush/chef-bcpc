
apt_repository "calico" do
  uri 'http://ppa.launchpad.net/project-calico/kilo/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key '3D40A6A7'
  keyserver 'keyserver.ubuntu.com'

end

template "/etc/apt/preferences.d/project-calico-pin-1001" do
  source "calico_apt_preferences.erb"
  mode 00644
end

apt_repository "bird" do
  uri 'http://ppa.launchpad.net/cz.nic-labs/bird/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
end

# get etcd setup
package "etcd"
package "python-etcd"
