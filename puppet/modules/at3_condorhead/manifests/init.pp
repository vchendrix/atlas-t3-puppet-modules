# Definition: at3_condorhead 
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
define at3_condorhead($condorpassword,$condor_allow_negotiator_extra,$clusterName, $filesystemdomain,
   $mountPoint,$dataNodes,$nameNodes,$fsDefaultName) {
  
  include cls_condor_base 
  class { 'condor::cls_condor_head':
    mountPoint	 	=> $mountPoint,
    filesystemdomain 	=> $filesystemdomain,
    condorpassword 	=> $condorpassword,
    condor_allow_negotiator_extra => $condor_allow_negotiator_extra,
  }
  class { 'hadoop::cls_hadoop_fuse': 
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  class { 'hadoop::hadoop_datanode':  
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
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
  
}

