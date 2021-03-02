# frozen_string_literal: true

require_relative 'ls_files'

class Format
  def initialize(files)
    @files = files
    @long_format = @files.long_format
  end

  def format_data
    @long_format ? build_long_format : build_short_format
  end

  private

  def build_long_format
    total = @files.total_fileblocks
    body = long_format_body
    "total #{total}\n#{body}"
  end

  def long_format_body
    @files.files_info.map do |file|
      long_format_row(file.build_data, *@files.max_sizes)
    end.join("\n")
  end

  def long_format_row(data, max_link, max_owner, max_group, max_size)
    [
      data[:type_and_mode],
      "  #{data[:link].rjust(max_link)}",
      " #{data[:owner].rjust(max_owner)}",
      "  #{data[:group].rjust(max_group)}",
      "  #{data[:size].rjust(max_size)}",
      " #{data[:time]}",
      " #{data[:name]}"
    ].join
  end

  def build_short_format
    row_count = (@files.file_names.count.to_f / 3).ceil
    nested_files = @files.file_names.each_slice(row_count).to_a
    transposed_files = nested_files[0].zip(*nested_files[1..])
    short_format_table(transposed_files, @files.max_filename_count)
  end

  def short_format_table(transposed_files, max_filename_count)
    transposed_files.map do |files|
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
