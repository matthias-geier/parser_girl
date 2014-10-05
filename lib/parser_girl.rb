require 'parser_girl/attributes'
require 'parser_girl/parser'
require 'parser_girl/proxy'

module ParserGirl
  def self.new(*args)
    return Parser.new(*args)
  end

  def self.find(xml, needle)
    return Parser.new(xml).find(needle)
  end
end
