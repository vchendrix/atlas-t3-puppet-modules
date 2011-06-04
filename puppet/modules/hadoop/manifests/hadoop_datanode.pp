# Definition: hadoop_datanode 
#   This definition manages the hadoop datanode installation
# 
# Parameters:
#  - $clusterName - Name of the haddop cluster being managed
#  - $dataNodes - List of datanodes to be managed by cluster
#  -  $fsDefaultName - file system default name should be of the
#                 for hdfs://host:port
#  -  $namenodes - List of the namenodes to managing hdfs
#
# Actions:
#  - Downloads and intalls Sun Java
#  - Download and installs hadoop_core from Cloudera
#  - Download, Configures, installs and starts Cloudera's Hadoop
#     datanode  service
#
# Requires
#  - Class['hadoop::cls_hadoop-core']
#  - Class['hadoop::cls_hadoop-cluster-config']
#
# Sample Usage:
#
#
define hadoop::hadoop_datanode($clusterName="atlas",$dataNodes=['datanode'],$fsDefaultName,$nameNodes=['namenode']) {
  class { 'hadoop::cls_hadoop_cluster_config':
    clusterName			=> $clusterName,
    dataNodes			=> $dataNodes,
    fsDefaultName		=> $fsDefaultName,
    nameNodes			=> $nameNodes,
  }
  class { 'hadoop_datanode':}
 
  class hadoop_datanode {

	  package { ["hadoop-0.20-datanode.noarch"]:
	    ensure => installed,
	    require => [Package["hadoop-0.20.noarch"],Class['hadoop::cls_hadoop_cluster_config']],
	  }   

	  file { ["/data","/data/dfs","/data/dfs/dn"]:
	    ensure    => directory,
	    owner     => "hdfs",
	    group     => "hadoop",
	    mode      => 0700,
	    recurse   => true,
	    require   => Package["hadoop-0.20-datanode.noarch"],
	  }   
	 
	  file { ["/mapred/","/mapred/local","/mapred/system"]:
	    ensure    => directory,
	    owner     => "mapred",
	    group     => "hadoop",
	    mode      => 0755,
	    recurse   => true,
	    require   => Package["hadoop-0.20-datanode.noarch"],
	  }   

	  service { 'hadoop-0.20-datanode':
	    ensure    => running,
	    enable    => true,
	    hasstatus => true,
	    hasrestart=> true,
	    require   => File["/data/dfs/dn"],
	  }   
  }

  Class['hadoop::cls_hadoop_cluster_config'] -> Class['hadoop_datanode']
}

