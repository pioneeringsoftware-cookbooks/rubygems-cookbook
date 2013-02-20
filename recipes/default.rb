#
# Cookbook Name:: rubygems
# Recipe:: default
#
# Copyright 2012–2013, Pioneering Software, United Kingdom
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
# EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
# OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#

include_recipe 'build-essential'

case node['platform']
  when 'debian', 'ubuntu'
    %w(libssl-dev zlib1g-dev libreadline6-dev libyaml-dev libffi-dev).each do |pkg|
      package pkg
    end
end

ruby = "ruby-#{node['ruby']['version']}"
rubygems = "rubygems-#{node['rubygems']['version']}"
ruby_tar = "#{ruby}.tar.gz"
rubygems_tar = "#{rubygems}.tgz"
ruby_src_url = "http://ftp.ruby-lang.org/pub/ruby/#{node['ruby']['version'].match(/[0-9]+\.[0-9]+/).to_s}/#{ruby_tar}"
rubygems_src_url = "http://production.cf.rubygems.org/rubygems/#{rubygems_tar}"

src = '/usr/local/src'
ruby_src = "#{src}/#{ruby}"
rubygems_src = "#{src}/#{rubygems}"

ruby_bin = "#{node['ruby']['prefix']}/bin/ruby"
gem_bin = "#{node['ruby']['prefix']}/bin/gem"

# ruby

remote_file "/tmp/#{ruby_tar}" do
  source ruby_src_url
  checksum node['ruby']['checksum']
  mode 0644
end

execute "tar --no-same-owner -xzf /tmp/#{ruby_tar}" do
  cwd src
  creates ruby_src
end

bash 'configure ruby' do
  cwd ruby_src
  code "./configure --prefix=#{node['ruby']['prefix']} --disable-install-doc"
  creates "#{ruby_src}/config.status"
end

bash 'make ruby' do
  cwd ruby_src
  code "make #{node['ruby']['make_opts']}"
  creates "#{ruby_src}/ruby"
end

bash 'install ruby' do
  cwd ruby_src
  code 'make install'
  not_if { File.exist?(ruby_bin) }
end

# rubygems

remote_file "/tmp/#{rubygems_tar}" do
  source rubygems_src_url
  checksum node['rubygems']['checksum']
  mode 0644
end

execute "tar --no-same-owner -xzf /tmp/#{rubygems_tar}" do
  cwd src
  creates rubygems_src
end

bash 'set up rubygems' do
  cwd rubygems_src
  code "#{node['ruby']['prefix']}/bin/ruby setup.rb"
  creates gem_bin
end

# gems

ruby_block 'set up default gem binary' do
  block do
    run_context.resource_collection.select do |resource|
      resource.resource_name == :gem_package
    end.each do |resource|
      resource.gem_binary gem_bin unless resource.gem_binary
    end
  end
end

gem_package 'bundler'
