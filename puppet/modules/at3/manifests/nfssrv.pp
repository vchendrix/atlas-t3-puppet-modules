define at3::nfssrv($share_root,$clientlist, $share_options = "rw,sync,no_root_squash") {

  exec { 'mk_share_root':
    command 	=> "mkdir -p $share_root",
    path 	=> ['/bin','/usr/bin'],
    creates 	=> $share_root,
  }

  file { $share_root:
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 755,
    require => Exec['mk_share_root']
  }
  
  file { "/etc/exports":
    owner => "root",
    group => "root",
    mode => 644,
    content => template("nfs/etc-exports.tpl"),
    notify => Service["nfs"],
  }
  
  package { "nfs-utils":
    ensure => installed,
  }
  
  service { [ "nfs", "nfslock", "portmap"]:
    hasstatus => true,
    hasrestart => true,
    ensure => running,
    enable => true,
    require => [Package["nfs-utils"],File[$share_root],File["/etc/exports"]]
  }
  
}

