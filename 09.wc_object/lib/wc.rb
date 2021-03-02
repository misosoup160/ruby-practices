#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'wc_string'

opt = OptionParser.new
options = { bites: false, lines: false, words: false }
opt.on('-c') { |v| options[:bites] = v }
opt.on('-l') { |v| options[:lines] = v }
opt.on('-w') { |v| options[:words] = v }
opt.parse!(ARGV)
pathnames = ARGV
input_text = ARGV.empty? ? readlines.join : ''

puts WcString.new(input_text, pathnames, options).print_data
