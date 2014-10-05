module ParserGirl
  module Attributes
    def [](key)
      return @attrs[key]
    end

    def to_h
      return @attrs.dup
    end
  end
end
