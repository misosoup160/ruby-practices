# frozen_string_literal: true

require 'pathname'
require_relative 'wc_files'

class Wc
  def initialize(options, input_text: '', file_names: [])
    @input_text = input_text
    @file_names = file_names
    @options = options
    @bites = options[:bites] || false
    @lines = options[:lines] || false
    @words = options[:words] || false
  end

  def run
    if @file_names.empty?
      @text = WcText.new(@input_text)
      text_info_row(*text_contents(@text))
    else
      @wcfiles = WcFiles.new(@file_names)
      lines = @wcfiles.files.map do |file|
        "#{text_info_row(*text_contents(file.text))} #{file.name}"
      end
      lines << "#{text_info_row(*sum_contents)} total" if @file_names.count > 1
      lines.join("\n")
    end
  end

  private

  def sum_contents
    [
      @wcfiles.total_lines,
      @wcfiles.total_words,
      @wcfiles.total_bites
    ]
  end

  def text_contents(text)
    [
      text.lines,
      text.words,
      text.bites
    ]
  end

  def text_info_row(lines, words, bites)
    if no_options?
      text_info = [lines, words, bites]
    else
      text_info = []
      text_info << lines if lines?
      text_info << words if words?
      text_info << bites if bites?
    end

    text_info.map { |v| v.to_s.rjust(8) }.join
  end

  def lines?
    @lines
  end

  def words?
    @words
  end

  def bites?
    @bites
  end

  def no_options?
    @options.values.each.none?
  end
end
