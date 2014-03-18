# Installs PHP packages
class lcphp (
  $memory_limit = '256M',
  $apc_shm_size = '256M'
  ) {

  # Install Apache
  class { "apache":
    mpm_module => 'prefork',
    default_vhost => false,
  }
  include apache::mod::rewrite
  include apache::mod::php

  # Install PHP
  class { "php":
    require => Class['apache'],
    augeas => true
  }
  php::module {
    "mysql":;
    "curl":;
    "gd":;
  }
  # Set the PHP memory limit:
  php::augeas { "php-memorylimit":
    entry  => 'PHP/memory_limit',
    value  => $memory_limit,
    notify => Class['apache::service']
  }

  # Install APC from PECL
  package { "libpcre3-dev": }
  php::pecl::module{ "apc":
    use_package => "no",
    config_file => '/etc/php5/conf.d/apc.ini',
    require => Package['libpcre3-dev']
  }
  # Set the APC memory limit:
  file_line { "apc_memory":
    path => '/etc/php5/conf.d/apc.ini',
    line => "apc.shm_size=${apc_shm_size}",
    match => "apc.shm_size",
    require => Php::Pecl::Module['apc']
  }
}
