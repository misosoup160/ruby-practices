# frozen_string_literal: true

require 'pathname'
require_relative 'ls_file'

class LsFiles
  attr_reader :long_format

  def initialize(pathname, long_format: false, reverse: false, dot_match: false)
    @pathname = pathname
    @long_format = long_format
    @reverse = reverse
    @dot_match = dot_match
  end

  def files_info
    file_paths = collect_file_paths
    file_paths.map { |file_path| LsFile.new(file_path) }
  end

  def file_names
    files_info.map(&:file_name)
  end

  def max_filename_count
    file_names.map(&:size).max
  end

  def max_sizes
    %i[link owner group size].map do |key|
      find_max_size(key)
    end
  end

  def total_fileblocks
    files_info.sum(&:file_blocks)
  end

  private

  def collect_file_paths
    pattern = @pathname.join('*')
    params = @dot_match ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*params).sort
    @reverse ? file_paths.reverse : file_paths
  end

  def find_max_size(key)
    files_info.map { |file| file.build_data[key].size }.max
  end
end
