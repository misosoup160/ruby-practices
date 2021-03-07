#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'wc'

opt = OptionParser.new
options = { bites: false, lines: false, words: false }
opt.on('-c') { |v| options[:bites] = v }
opt.on('-l') { |v| options[:lines] = v }
opt.on('-w') { |v| options[:words] = v }
opt.parse!(ARGV)
file_names = ARGV
input_text = ARGV.empty? ? readlines.join : ''

puts Wc.new(options, input_text: input_text, file_names: file_names).run
