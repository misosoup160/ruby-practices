# frozen_string_literal: true

require 'pathname'
require_relative 'wc_file'

class WcFiles
  attr_reader :files

  def initialize(file_names)
    @file_names = file_names
    @files = @file_names.map { |file_name| WcFile.new(file_name) }
  end

  def total_lines
    @files.sum { |file| file.text.lines }
  end

  def total_words
    @files.sum { |file| file.text.words }
  end

  def total_bites
    @files.sum { |file| file.text.bites }
  end
end
