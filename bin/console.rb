#!/usr/bin/env ruby

$: << File.expand_path("../../lib",__FILE__)
Dir.chdir(File.expand_path("../../", __FILE__)) do
  require "bundler/setup"
end
require 'tyrion'
require 'irb'

IRB.start

