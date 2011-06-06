$clusterName 	= 'altas'
$dataNodes 	= ['worker01']
$fsDefaultName 	= 'namenode:54310'
$nameNodes 	= ['namenode']
$mountPoint	= "/mnt/hdfs"

$hdfsFuseMount	= $mountPoint
$filesystemdomain = 'dyndns.org'
$condorpassword	= 'abcdefg'
$condor_allow_negotiator_extra = ''


node condorhead {
  class { 'hadoop::cls_hadoop_cluster_config':
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => 'atlas'
  }

  hadoop::hadoop_fuse { fuseclient:
    mountPoint		=> $mountPoint,
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  at3_condorhead { condorhead:
    hdfsFuseMount 	=> "$mountPoint",
    filesystemdomain 	=> 'dyndns.org',
    condorpassword 	=> $condorpassword,
    condor_allow_negotiator_extra => '',
  }
}

node namenode {
  
  class { 'hadoop::cls_hadoop_cluster_config':
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => 'atlas'
  }

  hadoop::hadoop_namenode{ namenode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 
  }
}

node worker01 { 
 
  class { 'hadoop::cls_hadoop_cluster_config':
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => 'atlas'
  }
  
  hadoop::hadoop_datanode{ worker01_datanode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 

  }
  hadoop::hadoop_fuse { worker01_fuseclient:
    mountPoint		=> $mountPoint,
    fsDefaultName 	=> $fsDefaultName, 
    dataNodes 		=> $dataNodes, 
    nameNodes 		=> $nameNodes, 
  }
  at3_condorworker{ worker01_condorworker:
    hdfsFuseMount  => "$mountPoint/user/root",
    condorheadaddr => 'condorhead',
    condorpassword => $condorpassword,  	
  }
}
