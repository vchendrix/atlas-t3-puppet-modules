# Class: condor::cls_condor_head
#   Configures and starts up the condor head 
#
# Parameters:
#   
# Actions:
#   - creates symlinks to condor shared configuration
#   - creates local configuration
#   - Creates password
#   - stars condor service
#
# Requires:
#   - Mount[$mountPoint]
#   
class condor::cls_condor_head($condorpassword,$condor_allow_negotiator_extra,$filesystemdomain,$mountPoint) {
  
    file { "${mountPoint}/condor":
      owner => "root",
      group => "root",
      ensure => directory,
      mode => 755,
      require => Package['condor'],
    }
    
    file { "${mountPoint}/condor/condor_config":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 644,
      content => template("condor/condor_config.tpl"),
      require => File["${mountPoint}/condor"],
    }

    file { "/etc/condor/condor_config":
      owner => "root",
      group => "root",
      ensure  => symlink,
      replace => true,
      require => File["${mountPoint}/condor"],      
      target    => "${mountPoint}/condor/condor_config",
    }

    file { "/etc/condor/condor_config.local":
      owner => "root",
      group => "root",
      mode => 644,
      content => template("condor/condor_head_config.local.tpl"),
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
