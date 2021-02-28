# frozen_string_literal: true

require 'pathname'

class WcString

  attr_reader :input_text, :pathname, :options, :bites, :lines, :words

  def initialize(input_text, pathname, options)
    @input_text = WcText.new(input_text)
    @pathname = pathname
    @options = options
    @bites = options[:bites]
    @lines = options[:lines]
    @words = options[:words]
  end

  def print_data
    "#{build_print_data} #{File.basename(pathname)}".rstrip
  end

  def build_print_data
    unless options.values.each.any?
      print_data = input_text.no_option_dataset.values
    else
      print_data = []
      print_data << input_text.bites if options[:bites]
      print_data << input_text.lines if options[:lines]
      print_data << input_text.words if options[:words]
    end
  
    print_data.map { |v| v.to_s.rjust(8) }.join
  end
end

class WcText
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def lines
    text.count("\n")
  end

  def words
    text.split(/\s+/).size
  end

  def bites
    text.bytesize
  end

  def no_option_dataset
    {
      lines: self.lines,
      words: self.words,
      bites: self.bites
    }
  end
end
