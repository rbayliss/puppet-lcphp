
class lcphp::xdebug(
  $remote_enable = 1,
  $remote_port = 9000,
  $remote_host = false,
  $idekey = false
) {

  include lcphp
  php::pecl::module { "xdebug":

  }

  php::augeas {
    "xdebug_remote_enable":
      target => '/etc/php5/conf.d/xdebug.ini',
      entry => 'PHP/xdebug.remote_enable',
      value => $remote_enable;
    "xdebug_remote_port":
      target => '/etc/php5/conf.d/xdebug.ini',
      entry => 'PHP/xdebug.remote_port',
      value => $remote_port;
    "xdebug_remote_host":
      target => '/etc/php5/conf.d/xdebug.ini',
      entry => 'PHP/xdebug.remote_host',
      ensure => $remote_host ? {
        false => 'absent',
        default => 'present'
      },
      value => $remote_host;
    "xdebug_idekey":
      target => '/etc/php5/conf.d/xdebug.ini',
      entry => 'PHP/xdebug.idekey',
      ensure => $idekey ? {
        false => 'absent',
        default => 'present'
      },
      value => $idekey;
  }
}