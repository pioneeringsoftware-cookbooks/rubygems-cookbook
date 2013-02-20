Description
===========

Compiles and installs Ruby and RubyGems from source at `/usr` by default. You
can customise the prefix path.

Include this cookbook's default recipe in order to find `ruby` and `gems` in
the default path, `/usr/bin`. The cookbook also sets up the default gem binary
for all packages that do not specify a gem binary. The installed Ruby therefore
becomes the default Ruby virtual machine for cookbook gems.

For build speed, the cookbook does not install Ruby documentation.

Requirements
============

Your box needs build essentials.

Attributes
==========

Defaults as follows. These are the latest stable build versions at the time of
writing. The Ruby prefix defines where to install the binaries, including the
`gem` binary. Make options specify 10 parallel build jobs. This makes better
use of available compute cycles when compiling the sources.

    default['ruby']['version'] = '1.9.3-p385'
    default['ruby']['checksum'] = '4b15df007f5935ec9696d427d8d6265b121d944d237a2342d5beeeba9b8309d0'
    default['ruby']['prefix'] = '/usr'
    default['ruby']['make_opts'] = '-j10'
    default['rubygems']['version'] = '1.8.25'
    default['rubygems']['checksum'] = '649348ddf8746887fb1ee79c55dc508f0627d3d0bfa7fcdbcd4edb24908f1cc8'

Usage
=====

Simply include the default recipe.

    include_recipe 'rubygems'
