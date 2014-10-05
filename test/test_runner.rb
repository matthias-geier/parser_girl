gem 'minitest'
require 'minitest/autorun'
require 'parser_girl'

path = File.dirname(__FILE__)
Dir["#{path}/*spec*.rb"].each{ |f| load f }
