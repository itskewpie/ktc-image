include_attribute "openstack-image::default"

default["openstack"]["image"]["syslog"]["use"] = true

case platform
when "ubuntu"
  default["openstack"]["image"]["platform"]["postgresql_python_packages"] = []
  default["openstack"]["image"]["platform"]["mysql_python_packages"] = []
  default["openstack"]["image"]["platform"]["image_packages"] = ["openstack"]
end

# process monitoring
default["openstack"]["image"]["api_processes"] = [
  { "name" =>  "glance-api", "shortname" =>  "glance-api" },
  { "name" =>  "glance-registry", "shortname" =>  "glance-registry" }
]
