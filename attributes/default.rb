# You can update the tarball checksums on OS X using shasum -a 256 followed by
# the path of the tarballs. Or, alternatively, use Curl as follows.
#
#   curl http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz | shasum -a 256
#   curl http://production.cf.rubygems.org/rubygems/rubygems-2.4.5.tgz | shasum -a 256
#

default['ruby']['version'] = '2.2.0'
default['ruby']['checksum'] = '7671e394abfb5d262fbcd3b27a71bf78737c7e9347fa21c39e58b0bb9c4840fc'
default['ruby']['prefix'] = '/usr'
default['ruby']['make_opts'] = '-j10'

default['rubygems']['version'] = '2.4.5'
default['rubygems']['checksum'] = '47d182ba52da02d4400601efbf62f64c25ff83856f8e269f8289333f292566d9'
