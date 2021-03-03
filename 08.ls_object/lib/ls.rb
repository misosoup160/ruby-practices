#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'ls_files'
require_relative 'ls_format'

opt = OptionParser.new

params = { long_format: false, reverse: false, dot_match: false }

opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.on('-a') { |v| params[:dot_match] = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)

ls_file_list = LsFileList.new(pathname, **params)
puts Format.new(ls_file_list).run
