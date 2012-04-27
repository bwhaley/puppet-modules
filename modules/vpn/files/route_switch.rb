#!/usr/bin/ruby

require 'rubygems'

# First install nokogiri (http://ow.ly/atZIc)
# Then gem install aws-sdk
require 'aws-sdk'

unless ARGV.length == 3 then
  print "Usage: #{__FILE__} <region> <current_instance_id> <new_instance_id>\n"
  exit 1
end

region=ARGV.shift
from=ARGV.shift
to=ARGV.shift

ec2=AWS::EC2.new(
  :access_key_id  => "<ec2 access key>",
  :secret_access_key  => "<ec2 secret key>"
  ).regions["<region>"]

ec2.route_tables.each { |table| 
  table.routes.each { |route|
    if route.target.id == from then route.replace(:instance=>to) end
  }
}

print "Replaced all routes with target #{from} with target #{to}\n"


