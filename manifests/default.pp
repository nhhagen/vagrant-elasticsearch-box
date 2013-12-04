define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly,
   }
}

class must-have {
  include apt
  apt::ppa { "ppa:webupd8team/java": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    before => Apt::Ppa["ppa:webupd8team/java"],
  }

  exec { 'apt-get update 2':
    command => '/usr/bin/apt-get update',
    require => [ Apt::Ppa["ppa:webupd8team/java"], Package["git-core"] ],
  }

  package { ['vim', 'curl', 'git-core', 'bash']:
    ensure => present,
    require => Exec['apt-get update'],
    before => Apt::Ppa['ppa:webupd8team/java'],
  }

  package { 'nginx':
    ensure => installed,
    require => Exec['apt-get update 2']
  }
 
  service { 'nginx':
    ensure => running,
    enable => true,
    hasrestart => true,
    require => Package['nginx']
  }

  file { '/etc/nginx/nginx.conf':
    ensure => link,
    source => '/vagrant/kibana/nginx.conf',
    notify => Service['nginx'],
    require => [ Package['nginx'], Exec['download_kibana'] ]
  }

  exec { 'download_kibana':
    command => 'git clone https://github.com/elasticsearch/kibana.git',
    cwd => '/home/vagrant',
    user => 'vagrant',
    path => '/usr/bin/:/bin/',
    require => [ Package['git-core'] ],
    logoutput => true,
  }

  file { '/home/vagrant/kibana/src/config.js':
    ensure => link,
    source => '/vagrant/kibana/config.js',
    notify => Service['nginx'],
    require => [ Package['nginx'], Exec['download_kibana'] ]
  }

  package { 'oracle-java7-installer':
    ensure => present,
    require => Exec['apt-get update 2'],
  }

  exec { "accept_license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    cwd => "/home/vagrant",
    user => "vagrant",
    path => "/usr/bin/:/bin/",
    require => Package["curl"],
    before => Package["oracle-java7-installer"],
    logoutput => true,
  }

  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.Beta2.deb',
    config => {
      'cluster.name' => 'vagrant_elasticsearch',
      'node.name' => $::ipaddress,
      'index' => {
        'number_of_replicas' => '0',
        'number_of_shards' => '1',
      },
      'network' => {
        'host' => $::ipaddress,
      },
      'path' => {
        'conf' => '/elasticsearch_home/config',
        'data' => '/vagrant/sample_data',
        'work' => '/elasticsearch_home/work',
        'logs' => '/elasticsearch_home/logs',
        'plugins' => '/elasticsearch_home/plugins'
      }
    }
  }
}

include must-have
