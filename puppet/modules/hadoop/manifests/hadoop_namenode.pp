# Definition: hadoop_namenode 
#   This definition manages the hadoop namenode installation
# 
# Parameters:
#  - $clusterName - Name of the haddop cluster being managed
#  - $dataNodes - List of datanodes to be managed by cluster
#  - $fsDefaultName - file system default name should be of the
#                 for hdfs://host:port
#  - $namenodes - List of the namenodes to managing hdfs
# Actions:
#  - Downloads and intalls Sun Java
#  - Download and installs hadoop_core from Cloudera
#  - Download, Configures, installs and starts Cloudera's Hadoop
#     namenode service
#
# Requires
#  - Class['hadoop::cls_hadoop-cluster-config']
#
# Sample Usage:
#
#
define hadoop::hadoop_namenode($clusterName="atlas",$dataNodes=['datanode'],$fsDefaultName,$nameNodes=['namenode']) {
  class { 'hadoop_namenode':}
 
  class hadoop_namenode {

	  package { ["hadoop-0.20-namenode.noarch"]:
	    ensure => installed,
	    require => [Package["hadoop-0.20.noarch"],Class['hadoop::cls_hadoop_cluster_config']],
	  }

	  file { ["/data","/data/dfs","/data/dfs/nn","/data/dfs/dn"]:
	    ensure    => directory,
	    owner	=> "hdfs",
	    group	=> "hadoop",
	    mode	=> 0700,
	    recurse 	=> true,
	    require	=> Package["hadoop-0.20-namenode.noarch"],
	  }
	 
	  file { ["/mapred/","/mapred/local","/mapred/system"]:
	    ensure    => directory,
	    owner	=> "mapred",
	    group	=> "hadoop",
	    mode	=> 0755,
	    recurse	=> true,
	    require	=> Package["hadoop-0.20-namenode.noarch"],
	  }

	  # This handles the chaining for the HDFS formatting step
	  File["/data/dfs/nn"] -> File["/mapred/system"] -> Exec["echo 'Y' | hadoop namenode -format"] ~> Service['hadoop-0.20-namenode']

	  # Format the namenode needs to happen after the hadoop is
	  # configure and before the service is started
	  exec { "echo 'Y' | hadoop namenode -format":
	    creates	=> "/data/dfs/nn/current/VERSION",
	    path      => ["/bin","/usr/bin", "/usr/sbin"],
	    user	=> hdfs,
	    logoutput => true,
	  }

	  service { 'hadoop-0.20-namenode':
	    ensure	=> running,
	    enable	=> true,
	    hasstatus => true,
	    hasrestart=> true,
	  }
  }
  
  Class['hadoop::cls_hadoop_cluster_config'] -> Class['hadoop_namenode']
}
