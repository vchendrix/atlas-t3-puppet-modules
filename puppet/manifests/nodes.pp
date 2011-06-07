$clusterName 	= 'altas'
$dataNodes 	= ['worker01']
$fsDefaultName 	= 'namenode:54310'
$nameNodes 	= ['namenode']
$mountPoint	= "/mnt/hdfs"

$filesystemdomain = 'atlasmagellan.dyndns.org'
$condorpassword	= 'abcdefg'
$condorheadaddr = 'condorhead'
$condor_allow_negotiator_extra = ''


node condorhead {
  include condor::cls_condor_base 
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
}

node namenode {

  hadoop::hadoop_cluster_config { atlas_tier3_hadoop_config:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName, 
  }

  hadoop::hadoop_namenode{ namenode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 
  }
}

node worker01 { 
 
  include condor::cls_condor_base 
  class { 'condor::cls_condor_worker':
    condorpassword 	=> $condorpassword,
    condorheadaddr	=> $condorheadaddr,
    mountPoint	 	=> $mountPoint,
  }
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
