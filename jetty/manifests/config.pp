class jetty::config {

  # local variables
  $repository_path = "$jetty::params::repository_path"
  $app_name = "$jetty::params::app_name"
  $username = "$jetty::params::username"
  $env_path = "$opdemand::inputs::env_path"
  $port = "$jetty::params::port"
  $concurrency = "$jetty::params::concurrency"  
  
  # rebuild upstart conf files
  exec {"rebuild-upstart":
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    cwd => $repository_path,
    command => "foreman export upstart /etc/init -a $app_name -u $username -e $env_path -t /var/cache/opdemand -p $port -c $concurrency",
    # rebuild on change of inputs.sh or the vcsrepo
    subscribe => [ File[$env_path], Vcsrepo[$repository_path] ],
    # notify the service on change
    notify => Service[$app_name],
    require => Class[Jetty::Install],
  }

}