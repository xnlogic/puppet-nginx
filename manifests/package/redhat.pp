# Class: nginx::package::redhat
#
# This module manages NGINX package installation on RedHat based systems
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package::redhat {
  $redhat_packages = ['nginx', 'gd', 'libXpm', 'libxslt']

  if downcase($::operatingsystem) == 'redhat' {
    $os_type = 'rhel'
  } else {
    $os_type = downcase($::operatingsystem)
  }

  if $::lsbmajdistrelease == undef {
    $os_rel = regsubst($::operatingsystemrelease, '\..*$', '')
  } else {
    $os_rel = $::lsbmajdistrelease
  }

  yumrepo { 'nginx-release':
    baseurl  => "http://nginx.org/packages/${os_type}/${os_rel}/\$basearch/",
    descr    => 'nginx repo',
    enabled  => '1',
    gpgcheck => '1',
    priority => '1',
    gpgkey => "http://nginx.org/keys/nginx_signing.key",
  }

  #Define file for nginx-repo so puppet doesn't delete it
  file { '/etc/yum.repos.d/nginx-release.repo':
    ensure  => present,
    require => Yumrepo['nginx-release'],
  }

  package { $redhat_packages:
    ensure  => present,
    require => Yumrepo['nginx-release'],
  }

}
