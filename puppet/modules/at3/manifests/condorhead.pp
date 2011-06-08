# Definition: at3::condorhead 
# 
# Parameters:
#  -  $condor_allow_negotiator_extra
#  -  $condorpassword
#  -  $filesystemdomain
#  -  $mountPoint - the mount point on the node
#  -  $dataNodes -
#  -  $namenodes -
#  -  $fsDefaultName
#
# Actions:
#
# Requires
#
# Sample Usage:
#
#
define at3::condorhead($condorpassword,$condor_allow_negotiator_extra,$clusterName, $filesystemdomain,
   $mountPoint,$dataNodes,$nameNodes,$fsDefaultName,$nfsShare,$nfsMount) {
  
  include condor::cls_condor_base 

  class { 'condor::cls_condor_head':
    mountPoint	 	=> $nfsMount,
    filesystemdomain 	=> $filesystemdomain,
    condorpassword 	=> $condorpassword,
    condor_allow_negotiator_extra => $condor_allow_negotiator_extra,
  }
  at3::nfsclient { atlas_nfs_client:
    source => $nfsShare,
    dest   => $nfsMount,
  }
  Service['nfs'] -> Class['condor::cls_condor_head']

  class { 'hadoop::cls_hadoop_fuse': 
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  hadoop::hadoop_datanode { atlas_condorhead_datanode:  
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodes, 
  }
  hadoop::hadoop_cluster_config { atlas_hadoop_cluster_config:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName,
  }
  hadoop::hdfs_fuse_mount{ condor_hdfs_fuse_mount:
    fileSystem	=> $fsDefaultName,
    path	=> '/',
    mountPoint => $mountPoint,
  }
  
  $rootDir = "/user/root"
  exec { make_hadoop_user_dir:
     command => "hadoop fs -mkdir -p $rootDir",
     path    => ['/bin','/usr/bin'],
     user    => 'hdfs',
     logoutput => true,
     creates => "${mountPoint}",
     require => Mount[$mountPoint],
  }
    
  exec { chown_user_root:
     command => "hadoop fs -chown -R root:root $rootDir",
     path    => ['/bin','/usr/bin'],
     user    => 'hdfs',
     logoutput => true,
     require  => Exec['make_hadoop_user_dir'],
  }

}

