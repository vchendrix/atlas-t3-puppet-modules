define at3_condorworker($condorheadaddr,$HDFSFuseMount,$condorpassword) {
#    $condorheadaddr=get_provider_attr($webaddr,$roleid,"CondorHeadAddr")
#    $HDFSFuseMount=get_provider_attr($webaddr,$roleid,"HDFSFuseMount")
#    $condorpassword=get_role_attr($webaddr,$roleid,"condorpassword")    
  
  include condor_base
  
  file { "/etc/condor/condor_config":
    owner => "root",
    group => "root",
    ensure  => symlink,
    replace => true,
    target    => "$HDFSFuseMount/condor/condor_config",
    notify => Service["condor"],
  }
  
  file { "/etc/condor/condor_config.local":
    owner => "root",
    group => "root",
    mode => 644,
    content => template("at3_condorworker/condor_config.local.tpl"),
    notify => Service["condor"],
  }
  
  exec { create_condorpassword:
    command => "condor_store_cred -c add -p $condorpassword",
    require => File["/etc/condor/condor_config","/etc/condor/condor_config.local"],
    creates => "/var/condor_credential",
  }
  
  service { [ "condor"]:
    hasstatus => true,
    hasrestart => true,
    ensure => running,
    enable => true,
    require => [Package["condor"], Exec["create_condorpassword"]],
  }
  
}
