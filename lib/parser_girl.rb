class ParserGirl
  def initialize(xml=nil)
    @xml = xml
    @result = nil
    @stack = nil
  end

  def find(needle, haystack_base=nil)
    haystack_base = @xml unless haystack_base
    return [] unless haystack_base

    haystack = haystack_base
    pos = 0
    @result = []
    @stack = []
    while true do
      if haystack =~ /\<([^!][^\>]*)\>/i
        content = $1 # tag-hit
        b = $`.length + 1 # relative beginning in haystack
        e = content.length + b + 1 # relative ending in haystack
        if content =~ /^([^\s]+)/ and $1.downcase == "script" and
            haystack =~ /\<\/script(\s[^\>]*)?\>/i
          e = $`.length + $&.length
        end

        if content =~ /^#{needle}(\s.*)?$/i
          push({:position => pos+e, :attrs => split_attr($1)})
        elsif content =~ /^\/#{needle}(\s.*)?$/i
          hash = pop(haystack_base, b+pos-1)
          if hash
            if block_given?
              @result.push(yield(hash[:content], hash[:attrs]))
            else
              @result.push(hash[:content])
            end
          end
        end
        pos += e
        haystack = haystack_base[pos, haystack_base.length-pos]
      else
        break
      end
    end
    @result
  end

  private
  def push(hash)
    @stack.push hash
  end

  def pop(haystack, current_position)
    if @stack.any?
      hash = @stack.pop
      hash[:content] = haystack[hash[:position],
        current_position-hash[:position]]
      hash[:end_position] = current_position
      hash
    end
  end

  def split_attr(attrs)
    attr_hash = {}
    while(1)
      if attrs =~ /\s*([^=]+)=((\"([^\"]+)\")|(\'([^\']+)\')|([^\s]+))/
        attrs = $'
        key = $1
        value = nil
        value = $7 if $7
        value = $6 if $6
        value = $4 if $4
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

