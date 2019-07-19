#\ --warn --port 8090
########
# #\ --warn --port 8090 --daemonize --pid ./app.pid
require 'rubygems'
require 'bundler/setup'
require File.expand_path '../app.rb', __FILE__
run Sinatra::Application