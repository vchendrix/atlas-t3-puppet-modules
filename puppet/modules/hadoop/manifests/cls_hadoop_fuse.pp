# Class: cls_hadoop_fuse 
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
#   - A hadoop cluster should be up and running
#
# Sample Usage:
#
#
class hadoop::cls_hadoop_fuse($fsDefaultName,$dataNodes,$nameNodes,$mountPoint="/mnt/hdfs") {
  
  
  package { ['hadoop-0.20-libhdfs.x86_64','hadoop-0.20-native.x86_64']:
    ensure	=> installed,
    require => Class['hadoop::cls_hadoop_core'],
  }

  package { ['hadoop-0.20-fuse.x86_64']:
    ensure	=> installed,
    require	=> [ Package['hadoop-0.20-libhdfs.x86_64'],Package['hadoop-0.20-native.x86_64']],
  }
  
}

