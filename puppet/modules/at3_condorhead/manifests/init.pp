class condor_base {
  exec { get_condor_repo:
     command => "wget -O /etc/yum.repos.d/condor-stable-rhel5.repo http://www.cs.wisc.edu/condor/yum/repo.d/condor-stable-rhel5.repo",
     creates => '/etc/yum.repos.d/condor-stable-rhel5.repo',
     path => ["/bin","/usr/bin", "/usr/sbin"],
     logoutput => true,
  }

  package { "condor":
    ensure => installed,
    require => Exec['get_condor_repo'],
  }
}


define at3_condorhead($hdfsFuseMount, $condorpassword,$condor_allow_negotiator_extra, $filesystemdomain) {

  #$hdfsFuseMount=get_provider_attr($webaddr,$roleid,"hdfsFuseMount")
  #  $filesystemdomain=get_role_attr($webaddr,$roleid,"FILESYSTEM_DOMAIN")
  #  $condorpassword=get_role_attr($webaddr,$roleid,"condorpassword")
  #  $condor_allow_negotiator_extra=""
  
    file { "$hdfsFuseMount/condor":
      owner => "root",
      group => "root",
      ensure => directory,
      mode => 755,
    }
    
    file { "$hdfsFuseMount/condor/condor_config":
      owner => "root",
      group => "root",
      mode => 644,
      content => template("at3_condorhead/condor_config.tpl"),
      require => File["$hdfsFuseMount/condor"],
    }

    file { "/etc/condor/condor_config":
      owner => "root",
      group => "root",
      ensure  => symlink,
      replace => true,
      require => File["$hdfsFuseMount/condor"],      
      target    => "$hdfsFuseMount/condor/condor_config",
    }

    file { "/etc/condor/condor_config.local":
      owner => "root",
      group => "root",
      mode => 644,
      content => template("at3_condorhead/condor_config.local.tpl"),
    }
    
    exec { create_condorpassword:
      command => "condor_store_cred -c add -p $condorpassword",
      require => File["/etc/condor/condor_config","/etc/condor/condor_config.local"],
      creates => "/var/condor_credentiald",
    }
    
    include condor_base
    
    service { [ "condor"]:
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => [Package["condor"],Exec["create_condorpassword"]],
    }

}

#    set_role_attr($webaddr,$roleid,"CondorHeadAddr","$fqdn")    

