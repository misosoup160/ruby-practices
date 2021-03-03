# frozen_string_literal: true

require_relative 'ls_files'

class Format
  def initialize(file_list)
    @file_list = file_list
    @long_format = @file_list.long_format
  end

  def run
    @long_format ? build_long_format : build_short_format
  end

  private

  def build_long_format
    total = @file_list.total_fileblocks
    body = long_format_body
    "total #{total}\n#{body}"
  end

  def long_format_body
    @file_list.ls_files.map do |file|
      long_format_row(file, *max_sizes)
    end.join("\n")
  end

  def long_format_row(file, max_link, max_owner, max_group, max_size)
    [
      "#{file.type}#{file.mode}",
      "  #{file.nlink.rjust(max_link)}",
      " #{file.owner.rjust(max_owner)}",
      "  #{file.group.rjust(max_group)}",
      "  #{file.bitesize.rjust(max_size)}",
      " #{file.mtime}",
      " #{file.name}"
    ].join
  end

  def max_sizes
    [
      @file_list.ls_files.map { |file| file.nlink.size }.max,
      @file_list.ls_files.map { |file| file.owner.size }.max,
      @file_list.ls_files.map { |file| file.group.size }.max,
      @file_list.ls_files.map { |file| file.bitesize.size }.max
    ]
  end

  def build_short_format
    row_count = (@file_list.file_names.count.to_f / 3).ceil
    nested_files = @file_list.file_names.each_slice(row_count).to_a
    transposed_files = nested_files[0].zip(*nested_files[1..])
    short_format_table(transposed_files, @file_list.max_filename_count)
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
