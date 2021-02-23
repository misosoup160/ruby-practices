# frozen_string_literal: true

require 'minitest/autorun'
require './ls.rb'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('/Users/mssp/scaffold_app')

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
    assert_equal expected, LsFiles.new(TARGET_PATHNAME).files_info
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
    assert_equal expected, LsFiles.new(TARGET_PATHNAME, dot_match: true).files_info
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
    assert_equal expected, LsFiles.new(TARGET_PATHNAME, reverse: true).files_info
  end

  def test_ls_files_long_format
    expected = <<~TEXT.chomp
      total 728
      -rw-r--r--    1 mssp  staff    1973 11 28 11:28 Gemfile
      -rw-r--r--    1 mssp  staff    5510 11 28 11:28 Gemfile.lock
      -rw-r--r--    1 mssp  staff     374 11 28 11:28 README.md
      -rw-r--r--    1 mssp  staff     227 11 28 11:28 Rakefile
      drwxr-xr-x   11 mssp  staff     352 11 28 11:28 app
      -rw-r--r--    1 mssp  staff    1722 11 28 11:28 babel.config.js
      drwxr-xr-x   10 mssp  staff     320 11 28 11:28 bin
      drwxr-xr-x   18 mssp  staff     576 11 28 11:28 config
      -rw-r--r--    1 mssp  staff     130 11 28 11:28 config.ru
      drwxr-xr-x    5 mssp  staff     160 11 28 11:42 db
      drwxr-xr-x    4 mssp  staff     128 11 28 11:28 lib
      drwxr-xr-x    4 mssp  staff     128 11 28 11:28 log
      drwxr-xr-x  773 mssp  staff   24736 11 28 11:28 node_modules
      -rw-r--r--    1 mssp  staff     321 11 28 11:28 package.json
      -rw-r--r--    1 mssp  staff     224 11 28 11:28 postcss.config.js
      drwxr-xr-x   10 mssp  staff     320 11 28 11:42 public
      drwxr-xr-x    3 mssp  staff      96 11 28 11:28 storage
      drwxr-xr-x   12 mssp  staff     384 11 28 11:28 test
      drwxr-xr-x    9 mssp  staff     288 11 28 11:39 tmp
      drwxr-xr-x    3 mssp  staff      96 11 28 11:28 vendor
      -rw-r--r--    1 mssp  staff  332040 11 28 11:28 yarn.lock
    TEXT
    assert_equal expected, LsFiles.new(TARGET_PATHNAME, long_format: true).files_info
  end

  # def test_ls_files_all_options
  #   expected = <<~TEXT.chomp
  #     total 752
  #     -rw-r--r--    1 mssp  staff  332040 11 28 11:28 yarn.lock
  #     drwxr-xr-x    3 mssp  staff      96 11 28 11:28 vendor
  #     drwxr-xr-x    9 mssp  staff     288 11 28 11:39 tmp
  #     drwxr-xr-x   12 mssp  staff     384 11 28 11:28 test
  #     drwxr-xr-x    3 mssp  staff      96 11 28 11:28 storage
  #     drwxr-xr-x   10 mssp  staff     320 11 28 11:42 public
  #     -rw-r--r--    1 mssp  staff     224 11 28 11:28 postcss.config.js
  #     -rw-r--r--    1 mssp  staff     321 11 28 11:28 package.json
  #     drwxr-xr-x  773 mssp  staff   24736 11 28 11:28 node_modules
  #     drwxr-xr-x    4 mssp  staff     128 11 28 11:28 log
  #     drwxr-xr-x    4 mssp  staff     128 11 28 11:28 lib
  #     drwxr-xr-x    5 mssp  staff     160 11 28 11:42 db
  #     -rw-r--r--    1 mssp  staff     130 11 28 11:28 config.ru
  #     drwxr-xr-x   18 mssp  staff     576 11 28 11:28 config
  #     drwxr-xr-x   10 mssp  staff     320 11 28 11:28 bin
  #     -rw-r--r--    1 mssp  staff    1722 11 28 11:28 babel.config.js
  #     drwxr-xr-x   11 mssp  staff     352 11 28 11:28 app
  #     -rw-r--r--    1 mssp  staff     227 11 28 11:28 Rakefile
  #     -rw-r--r--    1 mssp  staff     374 11 28 11:28 README.md
  #     -rw-r--r--    1 mssp  staff    5510 11 28 11:28 Gemfile.lock
  #     -rw-r--r--    1 mssp  staff    1973 11 28 11:28 Gemfile
  #     -rw-r--r--    1 mssp  staff       6 11 28 11:28 .ruby-version
  #     -rw-r--r--    1 mssp  staff     771 11 28 11:28 .gitignore
  #     drwxr-xr-x   10 mssp  staff     320 11 28 15:15 .git
  #     -rw-r--r--    1 mssp  staff       9 11 28 11:28 .browserslistrc
  #     drwxr-xr-x   67 mssp  staff    2144  2 23 11:32 ..
  #     drwxr-xr-x   27 mssp  staff     864 11 28 11:28 .
  #   TEXT
  #   assert_equal expected, LsFiles.new(TARGET_PATHNAME, long_format: true, reverse: true, dot_match: true).files_info
  # end
end
