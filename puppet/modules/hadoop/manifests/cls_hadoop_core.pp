# Class: hadoop::cls_hadoop_core
#
#     hadoop core needs to be install for any Hadoop daemon
#
# Parameters:
#   
# Actions:
#   - Sets up the cloudera-cdh3 yum repo
#   - installs hadoop core which can be used by any of the daemosn
#
# Requires:
#   - File['/etc/alternatives/java']
#   - Yumrepo['cloudera-cdh3']
#   - Class['java']
#   - Class['hadoop_cluster_config']
#   
class hadoop::cls_hadoop_core { 
   include hadoop::cls_sun_java

   # setup the Cloudera yum repository, which is an RPM repository.
   yumrepo { 'cloudera-cdh3':
     mirrorlist  => "http://archive.cloudera.com/redhat/cdh/3/mirrors",
     descr    => "Cloudera's Distribution for Hadoop, Version 3",
     enabled  => 1,
     priority => 1,
     gpgcheck => 0,
     gpgkey   => 'http://archive.cloudera.com/redhat/cdh/RPM-GPG-KEY-cloudera',
   }

  package { ["hadoop-0.20.noarch"]:
    ensure  => installed,
    require => [Class['hadoop::cls_sun_java'], Yumrepo['cloudera-cdh3'] ]
  }
}
