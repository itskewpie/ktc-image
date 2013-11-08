# process monitoring
default["openstack"]["image"]["api_processes"] = [
  { "name" =>  "glance-api", "shortname" =>  "glance-api" },
  { "name" =>  "glance-registry", "shortname" =>  "glance-registry" }
]
