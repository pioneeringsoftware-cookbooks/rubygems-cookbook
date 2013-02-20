# You can update the tarball checksums on OS X using shasum -a 256 followed by
# the path of the tarballs. Or, alternatively, use Curl as follows.
#
#   curl http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p385.tar.gz | shasum -a 256
#   curl http://http://production.cf.rubygems.org/rubygems/rubygems-1.8.25.tgz | shasum -a 256
#

default['ruby']['version'] = '1.9.3-p385'
default['ruby']['checksum'] = '4b15df007f5935ec9696d427d8d6265b121d944d237a2342d5beeeba9b8309d0'
default['ruby']['prefix'] = '/usr'
default['ruby']['make_opts'] = '-j10'

default['rubygems']['version'] = '1.8.25'
default['rubygems']['checksum'] = '649348ddf8746887fb1ee79c55dc508f0627d3d0bfa7fcdbcd4edb24908f1cc8'
