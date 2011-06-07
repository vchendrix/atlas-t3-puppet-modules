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
  
  at3_condorhead { atlas_condorhead:
    clusterName 	=> $clusterName, 
    condorpassword 	=> $condorpassword,
    condor_allow_negotiator_extra => $condor_allow_negotiator_extra,
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    filesystemdomain 	=> $filesystemdomain,
    mountPoint	 	=> $mountPoint,
    nameNodes 		=> $nameNodes, 
  }
}

node namenode {

  at3_namenode { atlas_namenode:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName, 
  }
}

node worker01 { 
 
 at3_condorworker { atlas_worker01_condorworker:
    clusterName   	=> $clusterName, 
    condorpassword 	=> $condorpassword,
    condorheadaddr	=> $condorheadaddr,
    dataNodes 		=> $dataNodes, 
    filesystemdomain	=> $filesystemdomain,
    fsDefaultName 	=> $fsDefaultName, 
    mountPoint	 	=> $mountPoint,
    nameNodes 		=> $nameNodes, 
  }
}
