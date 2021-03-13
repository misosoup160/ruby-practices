# frozen_string_literal: true

require 'pathname'
require 'forwardable'
require_relative 'wc_text'

class WcFile
  extend Forwardable
  delegate [:lines, :words, :bytes] => :@text

  attr_reader :name

  def initialize(file_name)
    @name = file_name
    @text = WcText.new(Pathname(@name).read)
  end
end
