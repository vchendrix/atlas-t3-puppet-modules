import "modules"

hadoop::hadoop_datanode{ mydatanode:
   clusterName                 => 'mycluster',
   dataNodes                   => ['dn01','dn02','dn03'],
   fsDefaultName               => 'nn:54310',
   nameNodes                   => ['namenode'],
}
