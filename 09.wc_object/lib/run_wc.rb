#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'wc'

opt = OptionParser.new
options = { byte_counts: false, line_counts: false, word_counts: false }
opt.on('-c') { |v| options[:byte_counts] = v }
opt.on('-l') { |v| options[:line_counts] = v }
opt.on('-w') { |v| options[:word_counts] = v }
opt.parse!(ARGV)
file_names = ARGV
input_text = ARGV.empty? ? readlines.join : ''

puts Wc.new(input_text: input_text, file_names: file_names, **options).run
