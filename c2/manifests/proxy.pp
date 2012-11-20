class c2::proxy (
  $username = "ubuntu",
  $group = "ubuntu",
  $repository_path = "/home/ubuntu/repo",  
) {
    
  $node_ppa = "ppa:chris-lea/node.js"
  $packages = [ "nodejs", "npm" ]
  
  # install ppa with precompiled node
  apt::ppa {$node_ppa:}
    
  package { $packages:
    ensure => present,
    require => Apt::Ppa[$node_ppa],
  }

  exec { "npm::install":
    command => "npm install",
    logoutput => false,   # log raw output from shell command
    cwd => "${repository_path}/c2-frontend",
    environment => "HOME=${repository_path}/../",
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => Package[$packages],
    subscribe => Vcsrepo[$repository_path],
  }

  exec { "node::build":
    command => "node build",
    logoutput => false,   # log raw output from shell command
    cwd => "$repository_path/c2-frontend",
    environment => "HOME=${repository_path}/../",
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => Exec["npm::install"],
    subscribe => Vcsrepo[$repository_path],
  }
  
}