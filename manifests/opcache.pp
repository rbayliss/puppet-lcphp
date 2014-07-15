
class lcphp::opcache(
  $version = 'system',
  $apc_shm_size = '256M',
  $opcache_size = '256M'
) {
  case $version {
    '5.5': {
      file_line { "opcache_memory":
        path => '/etc/php5/apache2/conf.d/05-opcache.ini',
        line => "opcache.memory_consumption=${opcache_size}",
        match => 'opcache.memory_consumption',
        require => Class['php'],
      }
    }
    default: {
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
  }

}