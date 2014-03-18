
class lcphp::default_vhost {

  include lcphp

  apache::vhost { 'lcdefault':
    override => ['All'],
    docroot => '/var/www',
    ip => '*',
    port => 80;
  }
}