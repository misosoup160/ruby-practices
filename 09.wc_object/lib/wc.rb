#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require './lib/wc_string'

opt = OptionParser.new
options = { bites: false, lines: false, words: false }
opt.on('-c') { |v| options[:bites] = v }
opt.on('-l') { |v| options[:lines] = v }
opt.on('-w') { |v| options[:words] = v }
opt.parse!(ARGV)
pathname = ARGV.empty? ? '' : Pathname(ARGV[0])
input_text = ARGV.empty? ? readlines.join : File.read(ARGV[0])
# p options

puts WcString.new(input_text, pathname, options).print_data

