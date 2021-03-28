# frozen_string_literal: true

require './lib/wc'
require 'minitest/autorun'

class WcTest < Minitest::Test
  def tesdt_without_options
    text = <<~TEXT
      total 32
      -rw-r--r--  1 mssp  staff   469  3  7 19:36 run_wc.rb
      -rwxr-xr-x  1 mssp  staff  1429  3  7 19:55 wc.rb
      -rw-r--r--  1 mssp  staff   597  3  7 19:39 wc_files.rb
      -rw-r--r--  1 mssp  staff   220  3  7 19:32 wc_text.rb
    TEXT

    expected = <<-TEXT.chomp
       5      38     224
    TEXT
    actual = Wc.new(input_text: text).run
    assert_equal expected, actual
  end

  def test_with_c_options
    text = <<~TEXT
      total 32
      -rw-r--r--  1 mssp  staff   469  3  7 19:36 run_wc.rb
      -rwxr-xr-x  1 mssp  staff  1429  3  7 19:55 wc.rb
      -rw-r--r--  1 mssp  staff   597  3  7 19:39 wc_files.rb
      -rw-r--r--  1 mssp  staff   220  3  7 19:32 wc_text.rb
    TEXT

    expected = <<-TEXT.chomp
     224
    TEXT
    actual = Wc.new(input_text: text, byte_counts: true).run
    assert_equal expected, actual
  end

  def test_with_l_options
    text = <<~TEXT
      total 32
      -rw-r--r--  1 mssp  staff   469  3  7 19:36 run_wc.rb
      -rwxr-xr-x  1 mssp  staff  1429  3  7 19:55 wc.rb
      -rw-r--r--  1 mssp  staff   597  3  7 19:39 wc_files.rb
      -rw-r--r--  1 mssp  staff   220  3  7 19:32 wc_text.rb
    TEXT

    expected = <<-TEXT.chomp
       5
    TEXT
    actual = Wc.new(input_text: text, line_counts: true).run
    assert_equal expected, actual
  end

  def test_with_w_options
    text = <<~TEXT
      total 32
      -rw-r--r--  1 mssp  staff   469  3  7 19:36 run_wc.rb
      -rwxr-xr-x  1 mssp  staff  1429  3  7 19:55 wc.rb
      -rw-r--r--  1 mssp  staff   597  3  7 19:39 wc_files.rb
      -rw-r--r--  1 mssp  staff   220  3  7 19:32 wc_text.rb
    TEXT

    expected = <<-TEXT.chomp
      38
    TEXT
    actual = Wc.new(input_text: text, word_counts: true).run
    assert_equal expected, actual
  end

  def test_one_file_without_options
    expected = <<-TEXT.chomp
      68     132    1407 ./lib/wc.rb
    TEXT
    actual = Wc.new(file_names: ['./lib/wc.rb']).run
    assert_equal expected, actual
  end

  def test_two_files_without_options
    expected = <<-TEXT.chomp
      68     132    1407 ./lib/wc.rb
      17      62     507 ./lib/run_wc.rb
      85     194    1914 total
    TEXT
    actual = Wc.new(file_names: ['./lib/wc.rb', './lib/run_wc.rb']).run
    assert_equal expected, actual
  end
end
