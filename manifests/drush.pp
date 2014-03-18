
class lcphp::drush($version = 'master') {

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
}
