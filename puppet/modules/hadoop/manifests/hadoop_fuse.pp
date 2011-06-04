# Definition: hadoop_fuse 
#   This definition manages the fuse storage  installation
# 
# Parameters:
#   - $fsDefaultName file system default name should be of the
#                 for hdfs://host:port
#   - $mountPoint where to mount hdfs, default is /mnt/hdfs
# Actions:
#   - Downloads and intalls Sun Java
#   - Download, Configures, installs and starts Cloudera's Hadoop
#     fuse  service
#
# Requires:
#   - hadooop_datanode definition
#
# Sample Usage:
#
#
define hadoop::hadoop_fuse($fsDefaultName,$mountPoint="/mnt/hdfs") {
  package { ['hadoop-0.20-libhdfs.x86_64','hadoop-0.20-native.x86_64']:
    ensure	=> installed,
    require	=> Package['hadoop-0.20.noarch'],
  }

  package { ['hadoop-0.20-fuse.x86_64']:
    ensure	=> installed,
    require	=> [ Package['hadoop-0.20-libhdfs.x86_64'],Package['hadoop-0.20-native.x86_64']],
  }

 file { [$mountPoint]:
    ensure  => directory,
    require	=> [Package['hadoop-0.20-fuse.x86_64']],
  }

  # hadoop-fuse-dfs#dfs://namenode:54310    /mnt/hdfs       fuse    allow_other,usetrash,rw 2       0
  $mountCount = "`mount | grep '/mnt/hdfs' | wc -l`"
  case $mountCount {
    '0':{ $mounted=false}
    'default':{$mounted=true}
  }
  
  if $mounted {
  mount { [$mountPoint]:
    atboot	=> true,
    device	=> "hadoop-fuse-dfs#dfs://${fsDefaultName}",
    ensure	=> mounted,
    fstype	=> fuse,
    pass	=> 0,
    dump	=> 0,
    options	=> 'allow_other,usetrash,rw',
    require	=> File[$mountPoint],
  }
  }

}

