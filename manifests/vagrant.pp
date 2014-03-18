
class lcphp::vagrant(
  $mysql_sock = false
) {

  include lcphp

  # Install socat mysql sock, if requested:
  php::conf { 'socat-mysql':
    path => '/etc/php5/conf.d/socat-mysql.ini',
    template => "lcphp/lc-mysql.erb",
    ensure => $mysql_sock ? {
      false => absent,
      default => present
    },
    notify => Class['apache::service'],
  }

  # @todo: Is this needed?
  file_line { "apache_env_user":
    path => "/etc/apache2/envvars",
    line => "export APACHE_RUN_USER=vagrant",
    match => "export APACHE_RUN_USER=",
    require => Package['httpd'],
    before => File["/var/lock/apache2"],
  }
  file_line { "apache_env_group":
    path => "/etc/apache2/envvars",
    line => "export APACHE_RUN_GROUP=vagrant",
    match => "export APACHE_RUN_GROUP=",
    require => Package['httpd'],
    before => File["/var/lock/apache2"],
  }
  file { "/var/lock/apache2":
    ensure => directory,
    owner => 'vagrant',
    recurse => true,
    require => Package['httpd'],
    notify => Class['apache::service'],
  }
}