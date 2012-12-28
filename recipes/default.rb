#
# Cookbook Name:: rubygems
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'build-essential'

case node['platform']
  when 'debian', 'ubuntu'
    %w(libssl-dev zlib1g-dev libreadline6-dev libyaml-dev).each do |pkg|
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

execute "tar -xzf /tmp/#{ruby_tar}" do
  cwd src
  creates ruby_src
end

bash 'configure ruby' do
  cwd ruby_src
  code "./configure --prefix=#{node['ruby']['prefix']}"
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

execute "tar -xzf /tmp/#{rubygems_tar}" do
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
