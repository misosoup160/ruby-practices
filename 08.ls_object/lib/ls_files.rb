# frozen_string_literal: true

require 'pathname'
require_relative 'ls_file'

class LsFileList
  attr_reader :long_format, :ls_files

  def initialize(pathname, long_format: false, reverse: false, dot_match: false)
    @pathname = pathname
    @long_format = long_format
    @reverse = reverse
    @dot_match = dot_match
    @ls_files = files
  end

  def file_names
    ls_files.map(&:name)
  end

  def max_filename_count
    file_names.map(&:size).max
  end

  def total_fileblocks
    ls_files.sum(&:fileblocks)
  end

  private

  def files
    file_paths = collect_file_paths
    file_paths.map { |file_path| LsFile.new(file_path) }
  end

  def collect_file_paths
    pattern = @pathname.join('*')
    params = @dot_match ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*params).sort
    @reverse ? file_paths.reverse : file_paths
  end
end
