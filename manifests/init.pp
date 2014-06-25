# Installs PHP packages
class lcphp (
  $memory_limit = '256M',
  $apc_shm_size = '256M',
  $max_filesize = '8M'
  ) {

  # Install Apache
  class { "apache":
    mpm_module => 'prefork',
    default_vhost => false,
  }
  include apache::mod::rewrite
  include apache::mod::php
  include apache::mod::headers

  # Install PHP
  class { "php":
    require => Class['apache'],
    augeas => true
  }
  php::module {
    "mysql":;
    "curl":;
    "gd":;
    "sqlite":;
  }

  # Set the PHP memory limit:
  Php::Augeas {
    notify => Class['apache::service']
  }
  php::augeas {
    "php-memorylimit":
      entry  => 'PHP/memory_limit',
      value  => $memory_limit;
    "php-upload_max_filesize":
      entry => "PHP/upload_max_filesize",
      value => $max_filesize;
    "php-post_max_size":
      entry => "PHP/post_max_size",
      value => $max_filesize;
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
