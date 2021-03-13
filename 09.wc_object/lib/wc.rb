# frozen_string_literal: true

require 'pathname'
require_relative 'wc_files'

class Wc
  def initialize(input_text: '', file_names: [], byte_counts: false, line_counts: false, word_counts: false)
    @input_text = input_text
    @file_names = file_names
    @byte_counts = byte_counts
    @line_counts = line_counts
    @word_counts = word_counts
  end

  def run
    if @file_names.empty?
      @text = WcText.new(@input_text)
      text_info_row(*text_contents(@text))
    else
      @wc_files = WcFiles.new(@file_names)
      lines = @wc_files.files.map do |file|
        "#{text_info_row(*text_contents(file.text))} #{file.name}"
      end
      lines << "#{text_info_row(*sum_contents)} total" if @file_names.count > 1
      lines.join("\n")
    end
  end

  private

  def sum_contents
    [
      @wc_files.total_lines,
      @wc_files.total_words,
      @wc_files.total_bytes
    ]
  end

  def text_contents(text)
    [
      text.lines,
      text.words,
      text.bytes
    ]
  end

  def text_info_row(lines, words, bytes)
    text_info = []
    text_info << lines if line_counts?
    text_info << words if word_counts?
    text_info << bytes if byte_counts?
    text_info = [lines, words, bytes] if text_info.empty?

    text_info.map { |v| v.to_s.rjust(8) }.join
  end

  def line_counts?
    @line_counts
  end

  def word_counts?
    @word_counts
  end

  def byte_counts?
    @byte_counts
  end
end
