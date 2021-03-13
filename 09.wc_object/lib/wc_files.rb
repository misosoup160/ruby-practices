# frozen_string_literal: true

require 'pathname'
require_relative 'wc_file'

class WcFiles
  include Enumerable

  def initialize(file_names)
    @file_names = file_names
    @files = @file_names.map { |file_name| WcFile.new(file_name) }
  end

  def each(&block)
    @files.each(&block)
  end

  def total_lines
    sum { |file| file.text.lines }
  end

  def total_words
    sum { |file| file.text.words }
  end

  def total_bytes
    sum { |file| file.text.bytes }
  end
end
