# frozen_string_literal: true

require 'etc'
require 'pathname'

MODE_TABLE = {
  '0' => '---',
  '1' => '-x-',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

class LsFile
  def initialize(file_path)
    @file_path = file_path
  end

  def file_stat
    File::Stat.new(@file_path)
  end

  def file_name
    File.basename(@file_path)
  end

  def file_blocks
    file_stat.blocks
  end

  def build_data
    {
      type_and_mode: format_type_and_mode,
      link: file_stat.nlink.to_s,
      owner: Etc.getpwuid(file_stat.uid).name,
      group: Etc.getgrgid(file_stat.gid).name,
      size: file_stat.size.to_s,
      time: file_stat.mtime.strftime('%_m %e %R'),
      name: file_name
    }
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

  private

  def format_type_and_mode
    type = format_type
    mode = format_mode
    "#{type}#{mode}"
  end

  def format_type
    case file_stat.ftype
    when 'directory'
      'd'
    when 'link'
      'l'
    else
      '-'
    end
  end

  def format_mode
    digits = file_stat.mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_TABLE)
  end
end
