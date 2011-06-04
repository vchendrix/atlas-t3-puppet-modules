# Class: hadoop::cls_hadoop_cluster_config
#
#   This is the hadoop configureation for all of the
#   hadoop services
#
# Parameters:
#   - $clusterName - Name of the haddop cluster being managed
#   - $dataNodes - List of datanodes to be managed by cluster
#   - $fsDefaultName - file system default name should be of the
#                 for hdfs://host:port
#   - $namenodes - List of the namenodes to managing hdfs
#
# Actions:
#   - Copies /etc/hadoop-0.20/conf.empty to /etc/hadoop-0.20/conf.${clusterName}_cluster
#   - Creates a symbolic link from /etc/hadoop-0.20/conf.${clusterName}_cluster 
#      to /etc/hadoop-0.20/conf
#   - Customizes core-site.xml, hadoop-env.sh, hdfs-site.xml, mapred-site.xml
#   - Creates /data and /mapred directories for the namenode service and mapred
#      service
# 
# Requires:
#   Class["hadoop::cls_hadoop_core"]
#
class hadoop::cls_hadoop_cluster_config($clusterName,$dataNodes,$fsDefaultName,$nameNodes) {
  include hadoop::cls_hadoop_core

  #################################################
  # This is the hadoop configuration for all of the 
  # hadoop services. 
  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    source  => "/etc/hadoop-0.20/conf.empty",
    recurse => true,
    require => Package["hadoop-0.20.noarch"],
  }

  file { "/etc/hadoop-0.20/conf":
    ensure => "/etc/hadoop-0.20/conf.${clusterName}_cluster",
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }    
  
  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/core-site.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("hadoop/core-site.xml.tpl"),
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }

  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/hadoop-env.sh":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("hadoop/hadoop-env.sh.tpl"),
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }
  
  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/hdfs-site.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("hadoop/hdfs-site.xml.tpl"),
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }
  
  #file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/mapred-site.xml":
  #  ensure  => present,
  #  owner   => "root",
  #  group   => "root",
  #  mode    => 0644,
  #  content => template("hadoop/mapred-site.xml.tpl"),
  #  require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  #}

  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/slaves":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("hadoop/slaves.tpl"),
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }

  file { "/etc/hadoop-0.20/conf.${clusterName}_cluster/masters":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 0644,
    content => template("hadoop/masters.tpl"),
    require => File["/etc/hadoop-0.20/conf.${clusterName}_cluster"],
  }
}
