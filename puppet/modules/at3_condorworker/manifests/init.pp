# Definition: at3_condorworker 
# 
# Parameters:
#  -  $condorheadaddr
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
define at3_condorworker($clusterName,$condorheadaddr,$condorpassword,$filesystemdomain,
   $mountPoint,$dataNodes,$nameNodes,$fsDefaultName,$nfsShare,$nfsMount) {
  
  include condor::cls_condor_base 
  class { 'condor::cls_condor_worker':
    condorpassword 	=> $condorpassword,
    condorheadaddr	=> $condorheadaddr,
    mountPoint	 	=> $nfsMount,
  }
  nfs::at3_nfsclient { atlas_nfs_client:
    source => $nfsShare,
    dest   => $nfsMount,
  }
  Service['nfs'] -> Class['condor::cls_condor_worker']
  class { 'hadoop::cls_hadoop_fuse': 
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  hadoop::hadoop_cluster_config { atlas_worker01_hadoop_cluster_config:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName, 
  }
  hadoop::hdfs_fuse_mount{ condor_worker01_hdfs_fuse_mount:
    fileSystem	=> $fsDefaultName,
    path	=> '/',
    mountPoint => $mountPoint,
  }
  hadoop::hadoop_datanode{ atlas_worker01_datanode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 
 } 
}

