# frozen_string_literal: true

require 'minitest/autorun'
require './lib/ls'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('/Users/mssp/my_books_app/books_app')

  def test_ls_files
    expected = <<~TEXT.chomp
      Gemfile           config            postcss.config.js
      Gemfile.lock      config.ru         public
      README.md         db                storage
      Rakefile          lib               test
      app               log               tmp
      babel.config.js   node_modules      vendor
      bin               package.json      yarn.lock
    TEXT
    ls_file_list = LsFileList.new(TARGET_PATHNAME)
    assert_equal expected, Format.new(ls_file_list).run
  end

  def test_ls_files_dot_match
    expected = <<~TEXT.chomp
      .                 Rakefile          node_modules
      ..                app               package.json
      .browserslistrc   babel.config.js   postcss.config.js
      .git              bin               public
      .gitignore        config            storage
      .ruby-version     config.ru         test
      Gemfile           db                tmp
      Gemfile.lock      lib               vendor
      README.md         log               yarn.lock
    TEXT
    ls_file_list = LsFileList.new(TARGET_PATHNAME, dot_match: true)
    assert_equal expected, Format.new(ls_file_list).run
  end

  def test_ls_files_reverse
    expected = <<~TEXT.chomp
      yarn.lock         package.json      bin
      vendor            node_modules      babel.config.js
      tmp               log               app
      test              lib               Rakefile
      storage           db                README.md
      public            config.ru         Gemfile.lock
      postcss.config.js config            Gemfile
    TEXT
    ls_file_list = LsFileList.new(TARGET_PATHNAME, reverse: true)
    assert_equal expected, Format.new(ls_file_list).run
  end

  def test_ls_files_long_format
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    ls_file_list = LsFileList.new(TARGET_PATHNAME, long_format: true)
    assert_equal expected, Format.new(ls_file_list).run
  end

  def test_ls_files_all_options
    expected = `ls -lra #{TARGET_PATHNAME}`.chomp
    ls_file_list = LsFileList.new(TARGET_PATHNAME, long_format: true, reverse: true, dot_match: true)
    assert_equal expected, Format.new(ls_file_list).run
  end
end
