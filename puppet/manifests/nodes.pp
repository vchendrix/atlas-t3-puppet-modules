$clusterName 	= 'altas'
$dataNodes 	= ['worker01']
$fsDefaultName 	= 'namenode:54310'
$nameNodes 	= ['namenode']
$mountPoint	= "/mnt/hdfs"

$hdfsFuseMount	= $mountPoint
$filesystemdomain = 'dyndns.org'
$condorpassword	= 'abcdefg'
$condor_allow_negotiator_extra = ''

class cls_users {
  
  $hasHadoopUserDir = 'hadoop fs -ls /user/root | grep "root root" | wc -l' 
  case $hasHadoopUserDir {
    '0': { $makeHadoopUserDir=true }
    'default': { $makeHadoopUserDir=false }
  }
  
  if $makeHadoopUserDir {
  exec { make_hadoop_user_dir:
    command => 'hadoop fs -mkdir -p /user/root/',
    path    => ['/bin','/usr/bin'],
    user    => 'hdfs',
    logoutput => true,
    creates => '/mnt/hdfs/user/root/',
    require => Class['cls_hadoopfuse'],
  }   

  exec { chown_user_root:
    command => 'hadoop fs -chown -R root:root /user/root',
    path    => ['/bin','/usr/bin'],
    user    => 'hdfs',
    logoutput => true,
    require  => Exec['make_hadoop_user_dir'],
  }
  }
}

class cls_cvmfs {
  at3_cvmfs {mycvmfs: squidproxy=>"http://cernvm.lbl.gov:3128",
  }
}

class cls_hadoopfuse {
  hadoop::hadoop_datanode{ mydatanode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 

  }
  hadoop::hadoop_fuse { myfuseclient:
    mountPoint	=> $mountPoint,
    fsDefaultName 	=> $fsDefaultName, 
  }
}

class cls_hadoopnamenode {
  hadoop::hadoop_namenode{ mynamenode:
    clusterName 	=> $clusterName, 
    dataNodes 		=> $dataNodes, 
    fsDefaultName 	=> $fsDefaultName, 
    nameNodes 		=> $nameNodess, 
  }
}

class cls_condorhead {
  include cls_hadoopfuse
  include cls_users
  at3_condorhead { mycondor:
    hdfsFuseMount => "$mountPoint/user/root",
    filesystemdomain => 'dyndns.org',
    condorpassword => 'abcdefg',
    condor_allow_negotiator_extra => '',
    require => [Class['cls_hadoopfuse'],Class['cls_users']],
  }
}

node condorhead { 

  include cls_condorhead
  include cls_hadoopfuse  
}

node namenode {
  include cls_users
  include cls_hadoopnamenode
}

node worker01 { 
 
  include cls_users
  include cls_hadoopfuse
  #at3_condorworker{ mycondorworker:
  #  hdfsFuseMount		   => '/mnt/hdfs',
  #  condorheadaddr		   => 'condorhead',
  #  condorpassword		   => 'abcdefg',  	
  #}
}
