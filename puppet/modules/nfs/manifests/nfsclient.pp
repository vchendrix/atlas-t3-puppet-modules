# Definition: nfs::nfsclient 
#
#    create an nfs mount point for given parameters
#
# Parameters:
#   $source - The nfs directory to mount should be of the 
#             for nfshost:/path
#   $dest   - the mount point
#
# Actions:
#   - creates the $dest directories
#   - mounts the directory to $source
#
# Requires:
#   
define nfs::nfsclient($source,$dest) {

  include nfs::cls_nfs_client

  exec { "create_mountpoint_${dest}":
    command => "mkdir -p $dest",
  }
  
  file { $dest:
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 755,
    require => Exec[ "create_mountpoint_${dest}"],
  }
  
  mount { $dest:
    atboot => true,
    device => $source,
    fstype => "nfs",
    name => $dest ,
    options => "defaults,rw,user,exec",
    ensure => "mounted",
    require => File[$dest],
  }
}
