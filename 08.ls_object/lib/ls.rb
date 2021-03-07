#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'ls_files'
require_relative 'ls_format'

opt = OptionParser.new

long_format = false, reverse = false, dot_match = false

opt.on('-l') { |v| long_format = v }
opt.on('-r') { |v| reverse = v }
opt.on('-a') { |v| dot_match = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)

ls_file_list = LsFileList.new(pathname, reverse: reverse, dot_match: dot_match)
puts LsFormat.new(ls_file_list, long_format: long_format).run
