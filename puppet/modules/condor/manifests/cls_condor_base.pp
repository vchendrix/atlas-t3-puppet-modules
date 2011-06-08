# Class: condor::cls_condor_base 
#  Base class for condor services
#
# Parameters:
#   
# Actions:
#   - Downloads and installs condor
#
# Requires:
#   
class condor::cls_condor_base {
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
