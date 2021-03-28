# frozen_string_literal: true

class WcText
  def initialize(text)
    @text = text
  end

  def lines
    @text.count("\n")
  end

  def words
    @text.split(/\s+/).size
  end

  def bytes
    @text.bytesize
  end
end
