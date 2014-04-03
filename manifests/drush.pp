
class lcphp::drush(
  $version = 'master',
  $db_su = undef,
  $db_su_pw = undef
) {

  include composer

  composer::project {"drush":
    project_name => 'drush/drush',
    target_dir => '/usr/share/drush',
    version => $version,
    keep_vcs => true,
  }

  file { "/usr/bin/drush" :
    ensure => 'link',
    target => '/usr/share/drush/drush',
    require => Composer::Project['drush']
  }

  if(!defined(File['/etc/drush/drushrc.php'])) {
    file { "/etc/drush":
      ensure => directory
    }
    file { "/etc/drush/drushrc.php":
      ensure => file,
      content => template("lcphp/drushrc.php.erb"),
      require => File['/etc/drush']
    }
  }
}
