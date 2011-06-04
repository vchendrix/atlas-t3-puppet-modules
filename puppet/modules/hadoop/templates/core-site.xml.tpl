<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/tmp/${user.name}</value>
    <description>A base for other temporary directories.</description>
  </property>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://<%= fsDefaultName %></value>
    <description>The name of the default file system.  A URI whose
  scheme and authority determine the FileSystem implementation.  The
  uri's scheme determines the config property (fs.SCHEME.impl) naming
  the FileSystem implementation class.  The uri's authority is used to
  determine the host, port, etc. for a filesystem.
  (i.e. hdfs://domainname:54310)
  </description>
  </property>
  <property>
    <name>io.file.buffer.size</name>
    <value>65536</value>
    <description/>
  </property>
  <property>
    <name>io.seqfile.compress.blocksize</name>
    <value>327680</value>
    <description/>
  </property>
  <property>
      <name>ipc.client.idlethreshhold</name>
      <value>2000</value>
  </property>
<property>
    <name>ipc.client.kill.max</name>
    <value>20</value>
</property>
<property>
    <name>ipc.server.listen.queue.size</name>
    <value>500</value>
</property>


</configuration>
