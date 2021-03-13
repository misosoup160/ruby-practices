# frozen_string_literal: true

require 'pathname'
require_relative 'wc_text'

class WcFile
  attr_reader :name, :text

  def initialize(file_name)
    @name = file_name
    @text = WcText.new(Pathname(@name).read)
  end
end
