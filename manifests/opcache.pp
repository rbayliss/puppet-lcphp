
class lcphp::apc($version, $size) {
  case $version {
    '5.5': {
      notify{ "Here I install the opcache"}
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
        line => "apc.shm_size=${$shm_size}",
        match => "apc.shm_size",
        require => Php::Pecl::Module['apc']
      }
    }
  }

}