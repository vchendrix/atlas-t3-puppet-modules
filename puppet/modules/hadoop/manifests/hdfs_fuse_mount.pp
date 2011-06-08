# Definition: hadoop::hdfs_fuse_mount 
#    Mounts hdfs using fuse to the given path and namenode
# 
# Parameters:
#  -  $filesystem - file system which is namenode and port e.g.  hdfs//host:port
#  -  $path - the path to the hdfs directory to be mounted
#  -  $mountPoint - the mount point on the node
#
# Actions:
#  - Ensures the given mount point exists
#  - Creates the mount in fstab and mounts it
#
# Requires
#  - Class['hadoop::cls_hadoop_fuse']
#
# Sample Usage:
#
#

define hadoop::hdfs_fuse_mount($fileSystem,$path='',$mountPoint) {


  file { [$mountPoint]:
    ensure  => directory,
    require	=> Class['hadoop::cls_hadoop_fuse'],
  }

  # hadoop-fuse-dfs#dfs://namenode:54310    /mnt/hdfs       fuse    allow_other,usetrash,rw 2       0
  mount { [$mountPoint]:
    atboot	=> true,
    device	=> "hadoop-fuse-dfs#dfs://${fsDefaultName}${path}",
    ensure	=> mounted,
    fstype	=> fuse,
    pass	=> 0,
    dump	=> 0,
    options	=> 'allow_other,usetrash,rw',
    remounts    => true,
    require	=> File[$mountPoint],
  }

}
