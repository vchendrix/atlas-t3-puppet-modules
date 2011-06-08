# Class: condor::cls_condor_worker 
#   Configures and starts up a condor worker node
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
#   - Mount[Mount[$mountPoint]] 
#   
class condor::cls_condor_worker ($condorheadaddr,$condorpassword,$mountPoint){
  file { "/etc/condor/condor_config":
    owner 	=> "root",
    group 	=> "root",
    ensure  	=> symlink,
    replace 	=> true,
    target    	=> "$mountPoint/condor/condor_config",
    notify 	=> Service["condor"],
    require	=> Mount[$mountPoint]
  }
  
  file { "/etc/condor/condor_config.local":
    owner 	=> "root",
    group 	=> "root",
    mode 	=> 644,
    content 	=> template("condor/condor_worker_config.local.tpl"),
    notify 	=> Service["condor"],
  }
  
  exec { create_condorpassword:
    command => "condor_store_cred -c add -p $condorpassword",
    require => File["/etc/condor/condor_config","/etc/condor/condor_config.local"],
    creates => "/var/condor_credential",
  }
  
  service { [ "condor"]:
    hasstatus 	=> true,
    hasrestart 	=> true,
    ensure 	=> running,
    enable 	=> true,
    require 	=> [Package["condor"], Exec["create_condorpassword"]],
  }
}
  
