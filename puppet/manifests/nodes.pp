$nfsShareRoot = "/export/share"
$nfsClientList = ["192.168.124.0/255.255.240.0"]
$nfsServerAddress = 'nfs'

$clusterName 	= 'altas'
$dataNodes 	= ['worker01']
$fsDefaultName 	= 'namenode:54310'
$nameNodes 	= ['namenode']
$mountPoint	= "/mnt/hdfs"

#$filesystemdomain = 'atlasmagellan.dyndns.org'
$filesystemdomain = 'condorfiles'
$condorpassword	= 'abcdefg'
$condorheadaddr = 'condorhead'
$condor_allow_negotiator_extra = ''
$installDir = '/opt'

node condorhead {
  
  at3::condorhead { atlas_condorhead:
    clusterName 	=> $clusterName, 
    condorpassword 	=> $condorpassword,
    condor_allow_negotiator_extra => $condor_allow_negotiator_extra,
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    filesystemdomain 	=> $filesystemdomain,
    mountPoint	 	=> $mountPoint,
    nameNodes 		=> $nameNodes, 
    nfsShare		=> "$nfsServerAddress:$nfsShareRoot",
    nfsMount		=> $nfsShareRoot,
  }
}

node nfs {

  at3::nfssrv { atlas_nfs:
    share_root	=> $nfsShareRoot,
    clientlist	=> $nfsClientList,
  }
}

node panda {
  
  class {'panda':
    nfsShare		=> "$nfsServerAddress:$nfsShareRoot",
    nfsMount		=> $nfsShareRoot,
  }

}

node namenode {

  at3::namenode { atlas_namenode:
    dataNodes	  => $dataNodes,
    fsDefaultName => $fsDefaultName,
    nameNodes	  => $nameNodes,
    clusterName   => $clusterName, 
  }
}


node worker01 { 
 
 at3::condorworker { atlas_worker01_condorworker:
    clusterName   	=> $clusterName, 
    condorpassword 	=> $condorpassword,
    condorheadaddr	=> $condorheadaddr,
    dataNodes 		=> $dataNodes, 
    filesystemdomain	=> $filesystemdomain,
    fsDefaultName 	=> $fsDefaultName, 
    mountPoint	 	=> $mountPoint,
    nameNodes 		=> $nameNodes, 
    nfsShare		=> "$nfsServerAddress:$nfsShareRoot",
    nfsMount		=> $nfsShareRoot,
  }
}
