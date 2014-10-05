module ParserGirl
  class Proxy
    def initialize(data)
      @data = data
    end

    def method_missing(method, *args, &blk)
      if ParserGirl.new.respond_to?(method)
        new_data = @data.map{ |d| d.send(method, *args, &blk) }
        return @data.size == 1 ? new_data.first : new_data
      else
        return @data.send(method, *args, &blk)
      end
    end
  end
end
