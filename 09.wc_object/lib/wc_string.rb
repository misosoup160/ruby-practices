# frozen_string_literal: true

require 'pathname'
require_relative 'wc_text'

class WcString
  def initialize(input_text, pathnames, options)
    @input_text = input_text
    @pathnames = pathnames
    @options = options
    @bites = options[:bites]
    @lines = options[:lines]
    @words = options[:words]
  end

  def print_data
    lines = files.map do |file|
      "#{text_info_row(file.dataset)} #{file.file_name}".rstrip
    end
    lines << "#{text_info_row(calc_total)} total" if @pathnames.count > 1
    lines.join("\n")
  end

  private

  def files
    if @pathnames.empty?
      [WcText.new('', @input_text)]
    else
      @pathnames.map { |path| WcText.new(path, @input_text) }
    end
  end

  def calc_total
    %i[lines words bites].to_h do |key|
      [key, files.sum { |file| file.dataset[key] }]
    end
  end

  def text_info_row(data)
    if @options.values.each.any?
      text_info = []
      text_info << data[:lines] if @lines
      text_info << data[:words] if @words
      text_info << data[:bites] if @bites
    else
      text_info = data.values
    end

    text_info.map { |v| v.to_s.rjust(8) }.join
  end
end
