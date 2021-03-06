# Installs PHP packages
class lcphp (
  $memory_limit = '256M',
  $opcache_size = '256M',
  $apc_shm_size = '256M',
  $max_filesize = '8M',
  $version = 'system'
  ) {


  class { "lcphp::version":
    before => Class['php'],
    version => $version
  }

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
    require => Class['php'],
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

  class { "lcphp::opcache":
    version => $version,
    apc_shm_size => $apc_shm_size,
    opcache_size => $opcache_size
  }
}
