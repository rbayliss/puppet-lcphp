
class lcphp::version($version) {
  case $version {
    '5.5': {
      case $operatingsystem {
        debian: {
          apt::source{ "dotdeb_php55":
            location => 'http://packages.dotdeb.org',
            repos => 'all',
            release => 'wheezy-php55',
            key => '89DF5277',
            key_server => 'keys.gnupg.net',
          }
        }
        default: { fail("PHP 5.5 Repositories are not supported for this operating system.") }
      }
    }
  }

}