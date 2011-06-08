class panda ($installDir='/opt/',$nfsMount,$nfsShare) {
  
  $pandaHome= "${installDir}/pilots"
  $pandaLogDir = "${nfsMount}/pilot"

  nfs::nfsclient { atlas_nfs_client:
    source => $nfsShare,
    dest   => $nfsMount,
  }

  # panda logs dir
  file { "~/panda_setup.sh":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("panda/panda_setup.sh.tpl"),
  }
  file { "$pandaHome/panda_manage.sh":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("panda/panda_manage.sh.tpl"),
  }
  file { ["$pandaHome","$pandaLogDir"]:
    ensure	=> directory,
    require => Mount[$nfsMount],
  }
 
  package { ['cron','subversion']:
    ensure => installed,
  }
  
  exec { checkout_autopilot:
    command => 'svn co http://svnweb.cern.ch/guest/panda/autopilot/trunk autopilot',
    cwd	    => "$installDir/pilots",
    path    => ['/bin','/usr/bin'],
    creates => "$installDir/pilots/autopilot",
    logoutput => true,
    try_sleep => 60,
    tries     => 3,
    require	=> Package['subversion'],
  }
  exec { checkout_monitor:
    command => 'svn co http://svnweb.cern.ch/guest/panda/monitor monitor',
    cwd	    => "$installDir/pilots",
    path    => ['/bin','/usr/bin'],
    creates => "$installDir/pilots/autopilot",
    logoutput => true,
    try_sleep => 60,
    tries     => 3,
    require	=> Package['subversion'],
  }
  exec { checkout_server:
    command => 'svn co http://svnweb.cern.ch/guest/panda/panda-server/current/pandaserver panda-server',
    cwd	    => "$installDir/pilots",
    path    => ['/bin','/usr/bin'],
    creates => "$installDir/pilots/autopilot",
    logoutput => true,
    try_sleep => 60,
    tries     => 3,
    require	=> Package['subversion'],
  }
}
