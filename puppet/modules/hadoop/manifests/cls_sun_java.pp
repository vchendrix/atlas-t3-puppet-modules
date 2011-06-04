# Class: hadoop::cls_sun_java
#   
#   This class downloads and installs the java binary fron Sun
#
# Parameters:
#
# Actions:
#   - Downloads the jdk 1.6.0 update 25 to /tmp
#   - Installs by running the doownloaded binary
#   - Sets java 1.6.0 update 25 as the default java version
#
# Requires:
#   
#
class hadoop::cls_sun_java {
   # Download the java binary from Sun 
   exec { 'wget http://download.java.net/jdk6/6u25/promoted/b03/binaries/jdk-6u25-ea-bin-b03-linux-amd64-27_feb_2011-rpm.bin':
     cwd 	 => '/tmp',
     creates 	 => '/tmp/jdk-6u25-ea-bin-b03-linux-amd64-27_feb_2011-rpm.bin',
     path 	 => ["/bin","/usr/bin", "/usr/sbin"],
     logoutput => true,
   }

   # Install the java binary
   exec { 'sh jdk-6u25-ea-bin-b03-linux-amd64-27_feb_2011-rpm.bin':
     cwd 	 => '/tmp',
     creates 	 => '/usr/java/jdk1.6.0_25/',
     logoutput => true,
     path 	 => ["/bin","/usr/bin", "/usr/sbin"],
     require   => Exec['wget http://download.java.net/jdk6/6u25/promoted/b03/binaries/jdk-6u25-ea-bin-b03-linux-amd64-27_feb_2011-rpm.bin'],
   }

  # Set Sun Java as the default VM
  file { '/etc/alternatives/java':
    ensure  => '/usr/java/jdk1.6.0_25/bin/java',
    require => Exec['sh jdk-6u25-ea-bin-b03-linux-amd64-27_feb_2011-rpm.bin'],
  }  
}
