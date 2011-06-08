
class nfs::cls_nfs_client {
  package { "nfs-utils":
    ensure => installed,
  }
  service { [ "nfs", "nfslock", "portmap"]:
    ensure => running,
    enable => true,
    require => Package["nfs-utils"],
    hasstatus => true,
    hasrestart => true,
  }
}
