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
   $mountPoint,$dataNodes,$nameNodes,$fsDefaultName) {
  
  include condor::cls_condor_base 
  class { 'condor::cls_condor_worker':
    condorpassword 	=> $condorpassword,
    condorheadaddr	=> $condorheadaddr,
    mountPoint	 	=> $mountPoint,
    filesystemdomain 	=> $filesystemdomain,
  }
  class { 'hadoop::cls_hadoop_fuse': 
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  hadoop::cls_hadoop_cluster_config { atlas_hadoop_cluster_config:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName, 
  }
  hadoop::hdfs_fuse_mount{ condor_hdfs_fuse_mount:
    filesystem	=> $fsDefaultName,
    path	=> '/',
    mountPoint => $mountPoint,
  }
  class { 'hadoop::hadoop_datanode': 
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 
  }
  
}

