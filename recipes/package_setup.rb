# setup os for

group node["openstack"]["image"]["group"] do
  system true
end

user node["openstack"]["image"]["user"] do
  home "/var/lib/glance"
  gid node["openstack"]["image"]["group"]
  shell "/bin/sh"
  system  true
  supports :manage_home => true
end

directory "/var/log/glance" do
  owner node["openstack"]["image"]["user"]
  group node["openstack"]["image"]["group"]
  mode 00755
end

%w/
  glance-api
  glance-registry
/.each do |p|
  cookbook_file "/etc/init/#{p}.conf" do
    source "etc/init/#{p}.conf"
    owner "root"
    group "root"
    mode 00644
  end

  link "/etc/init.d/#{p}" do
    to "/lib/init/upstart-job"
  end
end

%w/
  glance-api
  glance-cache-cleaner
  glance-cache-manage
  glance-cache-prefetcher
  glance-cache-pruner
  glance-control
  glance-manage
  glance-registry
  glance-replicator
  glance-scrubber
/.each do |p|
  link "/usr/bin/#{p}" do
    to "/opt/openstack/glance/bin/#{p}"
  end
end
