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
  
  $rootDir = '/user/root'
  #$hdfsFuseMount=get_provider_attr($webaddr,$roleid,"hdfsFuseMount")
  #  $filesystemdomain=get_role_attr($webaddr,$roleid,"FILESYSTEM_DOMAIN")
  #  $condorpassword=get_role_attr($webaddr,$roleid,"condorpassword")
  #  $condor_allow_negotiator_extra=""
  include condor_base 
  class { 'condorhead':}
  
  class condorhead {
  
   exec { make_hadoop_user_dir:
     command => "hadoop fs -mkdir -p $rootDir",
     path    => ['/bin','/usr/bin'],
     user    => 'hdfs',
     logoutput => true,
     creates => "$hdfsFuseMount$rootDir",
    }
    
    exec { chown_user_root:
     command => "hadoop fs -chown -R root:root $rootDir",
     path    => ['/bin','/usr/bin'],
     user    => 'hdfs',
     logoutput => true,
     require  => Exec['make_hadoop_user_dir'],
   }

    file { "$hdfsFuseMount$rootDir/condor":
      owner => "root",
      group => "root",
      ensure => directory,
      mode => 755,
      require => Package['condor'],
    }
    
    file { "$hdfsFuseMount$rootDir/condor/condor_config":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 644,
      content => template("at3_condorhead/condor_config.tpl"),
      require => File["$hdfsFuseMount$rootDir/condor"],
    }

    file { "/etc/condor/condor_config":
      owner => "root",
      group => "root",
      ensure  => symlink,
      replace => true,
      require => File["$hdfsFuseMount$rootDir/condor"],      
      target    => "$hdfsFuseMount$rootDir/condor/condor_config",
    }

    file { "/etc/condor/condor_config.local":
      owner => "root",
      group => "root",
      mode => 644,
      content => template("at3_condorhead/condor_config.local.tpl"),
      require => Package['condor'],
    }
    
    exec { create_condorpassword:
      command => "condor_store_cred -c add -p $condorpassword",
      require => File["/etc/condor/condor_config","/etc/condor/condor_config.local"],
      creates => "/var/condor_credentiald",
    }
    
    service { [ "condor"]:
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => [Exec["create_condorpassword"]],
    }

  }
  
  Class['condor_base'] -> Class['condorhead']
}

#    set_role_attr($webaddr,$roleid,"CondorHeadAddr","$fqdn")    

