class opsview($url, $username, $password)
{
  file { '/etc/puppet/opsview.conf':
    ensure  => 'present',
    content => template('opsview/etc/puppet/opsview.conf.erb'),
    mode    => '0644', # TODO: consider stricter permissions
  }

  case $::osfamily {
    'RedHat' : {
      $packages = [ Package['rubygems'], Package['ruby-devel'], Package['gcc'], Package['make'],]
    }
    'Debian' : {
      $packages = [ Package['rubygems'], Package['ruby-dev'], Package['gcc'], Package['make'], ]
    }
    default : {
      fail("Unsupported osfamily: \"${::osfamily}\"")
    }
  }

  package { ['rest-client', 'json']:
    ensure   => 'present',
    provider => 'gem',
    require  => $packages
  }
}
