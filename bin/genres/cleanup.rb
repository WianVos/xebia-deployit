#!/usr/bin/env /opt/puppet/bin/ruby
require 'fileutils'


@libdir = "../../lib/puppet"
@typedir = "#{@libdir}/type"
@providerdir = "#{@libdir}/provider"
@tmpdir = "/var/tmp/cleanup"
@timestamp = Time.now.to_f

#get a list of all the generated types

types_result = Dir["#{@typedir}/*"].select{|f| File.file?(f)}.select{|filepath| File.readlines(filepath).grep(/generated with genres.rb/).any? }
	

#get a list of all the generated providers



provider_result = Dir["#{@providerdir}/*"].select{|d| File.directory?(d)}.select{|dir| File.file?("#{dir}/generated_restclient.rb")}



# create temporary directory
FileUtils.mkdir_p(@tmpdir) unless File.exists?(@tmpdir)
FileUtils.mkdir_p("#{@tmpdir}/#{@timestamp}/type") unless File.exists?("#{@tmpdir}/#{@timestamp}/type")
FileUtils.mkdir_p("#{@tmpdir}/#{@timestamp}/provider") unless File.exists?("#{@tmpdir}/#{@timestamp}/provider")


types_result.each do |fp| 
	fBasename = File.basename(fp)
	newfile =  "#{@tmpdir}/#{@timestamp}/type/#{fBasename}"
	p "#{fp} --> #{newfile}"
	FileUtils.move fp, newfile
end

provider_result.each do |pd|
	pDirname = File.basename(pd)
	newfile = "#{@tmpdir}/#{@timestamp}/provider/#{pDirname}/generated_restclient.rb"
	p "#{pd}/generated_restclient.rb --> #{newfile}"
	FileUtils.mkdir_p("#{@tmpdir}/#{@timestamp}/provider/#{pDirname}")
	FileUtils.move pd, newfile
end