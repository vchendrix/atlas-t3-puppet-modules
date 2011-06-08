class panda ($installDir='/opt/',$nfsMount,$nfsShare) {
  
  $pandaHome= "${installDir}/pilots"
  $pandaLogDir = "${nfsMount}/pilot"

  nfs::nfsclient { atlas_nfs_client:
    source => $nfsShare,
    dest   => $nfsMount,
  }

  # panda logs dir
  file { "/root/panda_setup.sh":
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
 
  package { ['python','subversion']:
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

  cron { pilot_submission:
    command => "~/pilots/autopilot/pilotCron.sh --queue=LBL_MAGELLAN_TEST --pandasite=LBL_MAGELLAN_TEST --pilot=atlasTier3New > ~/.pilotCron.txt",
    user => root,
    hour => [0,6,12,18],
    minute => 5 
  }
  cron { pilot_monitor:
    command => "~/pilots/autopilot/pilotCron.sh --monitor --nocheck > ~/.pilotMon.txt",
    user => root,
    hour => [0,6,12,18],
    minute => 5 
  }
  cron { pilot_maintenance:
    command => "~/pilots/panda_manage.sh > ~/.pilotManage.txt",
    user => root,
    hour => [0,6,12,18],
    minute => 5 
  }
  
}
