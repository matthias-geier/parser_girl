module ParserGirl
  class Parser
    include Attributes

    def initialize(xml=nil, attrs=nil)
      @xml = xml
      @attrs = attrs
      @stack = nil
    end

    def content
      return @xml.dup
    end

    def find(needle)
      haystack_base = @xml

      haystack = haystack_base
      pos = 0
      result = []
      @stack = []
      while true do
        break unless haystack =~ /\<([^!][^\>]*)\>/i

        content = $1 # tag-hit
        b = $`.length + 1 # relative beginning in haystack
        e = content.length + b + 1 # relative ending in haystack

        if content =~ /^([^\s]+)/ && $1.downcase == "script" &&
          haystack =~ /\<\/script(\s[^\>]*)?\>/i

          e = $`.length + $&.length
        end

        if content =~ /^#{needle}(\s.*)?$/i
          @stack << { :position => pos+e, :attrs => split_attr($1) }
        elsif content =~ /^\/#{needle}(\s.*)?$/i
          hash = pop(haystack_base, b+pos-1)
          result << Parser.new(hash[:content], hash[:attrs]) if hash
        end
        pos += e
        haystack = haystack_base[pos, haystack_base.length-pos]
      end
      # pop rest and append
      result += @stack.map{ |hash| Parser.new("", hash[:attrs]) }
      return Proxy.new(result)
    end

    protected
    def pop(haystack, current_position)
      return unless @stack.any?
      hash = @stack.pop
      hash[:content] = haystack[hash[:position],
        current_position-hash[:position]]
      hash[:end_position] = current_position
      hash
    end

    def split_attr(attrs)
      attr_hash = {}
      while(1)
        if attrs =~ /\s*([^=]+)=((\"([^\"]+)\")|(\'([^\']+)\')|([^\s]+))/
          attrs = $'
          key = $1
          value = [$7, $6, $4].detect{ |v| !v.nil? }
          if value
            value.gsub! "\"", "\\\""
            value.gsub! "'", "\\'"
          end
          attr_hash[key.downcase.to_sym] = value
        else
          break
        end
      end
      attr_hash
    end
  end
end
