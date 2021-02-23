# frozen_string_literal: true

require 'pathname'
require './lib/ls_file'

class LsFiles
  attr_reader :pathname, :long_format, :reverse, :dot_match, :file_names, :files

  def initialize(pathname, long_format: false, reverse: false, dot_match: false)
    @pathname = pathname
    @long_format = long_format
    @reverse = reverse
    @dot_match = dot_match
  end

  def files_info
    file_paths = collect_file_paths
    files = file_paths.map { |f| LsFile.new(f) }
    long_format ? LsLongFormat.new(files).info : LsShortFormat.new(files).info
  end

  private

  def collect_file_paths
    pattern = pathname.join('*')
    params = dot_match ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*params).sort
    reverse ? file_paths.reverse : file_paths
  end
end

class LsLongFormat
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def info
    total = files.sum(&:file_blocks)
    body = long_format_body
    "total #{total}\n#{body}"
  end

  private

  def long_format_body
    max_sizes = %i[link owner group size].map do |key|
      find_max_size(key)
    end
    files.map do |file|
      file.long_format_row(file.build_data, *max_sizes)
    end.join("\n")
  end

  def find_max_size(key)
    files.map { |file| file.build_data[key].size }.max
  end
end

class LsShortFormat
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def info
    file_names = files.map(&:file_name)
    max_filename_count = file_names.map(&:size).max
    row_count = (file_names.count.to_f / 3).ceil
    nested_files = file_names.each_slice(row_count).to_a
    transposed_failes = nested_files[0].zip(*nested_files[1..])
    format_table(transposed_failes, max_filename_count)
  end

  private

  def format_table(transposed_failes, max_filename_count)
    transposed_failes.map do |files|
      shot_format_row(files, max_filename_count)
    end.join("\n")
  end

  def shot_format_row(files, max_filename_count)
    files.map do |file|
      file ||= ''
      file.ljust(max_filename_count + 1)
    end.join.rstrip
  end
end
