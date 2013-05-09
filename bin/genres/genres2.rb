#!/usr/bin/env /opt/puppet/bin/ruby

require 'lib/Generator.rb'

x = Genres::Generator.new('./rest.xml', "jetty")
x.do
