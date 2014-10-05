gem 'minitest'
require 'minitest/autorun'

path = File.dirname(__FILE__)
Dir["#{path}/*spec*.rb"].each{ |f| load f }
