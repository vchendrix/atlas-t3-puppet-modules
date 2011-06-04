<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>http://<%= mapredJobTrackerHostPort %></value>
    <description>The host and port that the MapReduce job tracker runs
              at.  If "local", then jobs are run in-process as a single map
              and reduce task.
        </description>
  </property>
  <property>
        <name>mapred.local.dir</name>
        <value>/data/mapred/local</value>
  </property>
  <property>
        <name>mapred.system.dir</name>
        <value>/mapred/system</value>
  </property>
  <property>
    <name>mapred.job.reuse.jvm.num.tasks</name>
    <value>-1</value>
  </property>
  <property>
    <name>mapred.tasktracker.map.tasks.maximum</name>
    <value>3</value>
    <description/>
  </property>
  <property>
    <name>mapred.child.java.opts</name>
    <value>-Xmx512m -XX:+UseConcMarkSweepGC</value>
    <description/>
  </property>
  <property>
    <name>mapred.jobtracker.completeuserjobs.maximum</name>
    <value>100</value>
    <description/>
  </property>
  <property>
    <name>mapred.reduce.parallel.copies</name>
    <value>20</value>
    <description/>
  </property>
  <property>
    <name>mapred.job.tracker.handler.count</name>
    <value>10</value>
    <description/>
  </property>
  <property>
    <name>mapred.reduce.slowstart.completed.maps</name>
    <value>0.1</value>
    <description/>
  </property>
  <property>
    <name>io.sort.factor</name>
    <value>25</value>
    <description/>
  </property>
  <property>
    <name>io.sort.mb</name>
    <value>250</value>
    <description/>
  </property>
</configuration>
