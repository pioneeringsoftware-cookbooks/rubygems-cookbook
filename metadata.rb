maintainer       "Pioneering Software, United Kingdom"
maintainer_email "roy@pioneeringsoftware.co.uk"
license          "All rights reserved"
description      "Installs/Configures Ruby and RubyGems"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

depends 'build-essential'

%w(debian ubuntu).each do |os|
  supports os
end
