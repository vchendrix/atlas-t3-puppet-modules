<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
        <name>dfs.name.dir</name>
        <value>/data/dfs/nn</value>
  </property>
  <property>
        <name>dfs.data.dir</name>
        <value>/data/dfs/dn</value>
  </property>
  <property>
        <name>dfs.data.node</name>
        <value>134217728</value>
  </property>
  <property>
    <name> dfs.namenode.handler.count </name>
    <value>20</value>
    <description/>
  </property>
  <property>
    <name>dfs.datanode.handler.count</name>
    <value>20</value>
    <description/>
  </property>
  <property>
      <name>dfs.datanode.socket.write.timeout</name>
      <value>0</value>
  </property>
  <property>
    <name>dfs.datanode.max.xcievers</name>
    <value>3000</value>
    <description/>
  </property>
  <property>
    <name>dfs.replication</name>
    <value>3</value>
    <description/>
  </property>
  <!--property>
      <name>dfs.support.append</name>
      <value>true</value>
  </property-->
</configuration>
