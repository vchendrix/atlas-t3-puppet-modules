import "modules"
import "nodes"

filebucket { main: server => puppet }

File { backup => main }
Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" }

node default {
}

file { "/etc/passwd":
  owner => "root",
  group => "bin",
  mode  => 644,
}
