# frozen_string_literal: true

class WcText
  def initialize(pathname, input_text)
    @pathname = pathname || ''
    @text = input_text.empty? ? file_text : input_text
  end

  def file_name
    @pathname.empty? ? '' : File.basename(@pathname)
  end

  def dataset
    {
      lines: lines,
      words: words,
      bites: bites
    }
  end

  private

  def file_text
    File.read(@pathname) unless @pathname.empty?
  end

  def lines
    @text.count("\n")
  end

  def words
    @text.split(/\s+/).size
  end

  def bites
    @text.bytesize
  end
end
