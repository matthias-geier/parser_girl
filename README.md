# ParserGirl is minimal very fast xml/html parser.

It consists of exactly one method, "find" which will take a tag-name like "div"
or "a" as string. "find" returns a Proxy of results that exposes either the
resultset array or a new instance of the parser to any method called.

The HTML or XML fed to the parser should be newline-free!

### Sample finds are:

```ruby
  p = ParserGirl.new(ANY_XML)
  proxy = p.find("div")
  proxies_inside_proxy = proxy.find("a")
```

### Accessing attributes and content

```ruby
  div_inside_parser_object = ParserGirl.find(ANY_HTML, "div").first
  div_inside_parser_object.content
  => "<i>This is my content</i>"
  div_inside_parser_object.to_h
  => { :class => "btn cookies", :id => "button1" }
  div_inside_parser_object[:class]
  => "btn_cookies"
```

### Easy mapping through results

As a sidenote, when the proxy only contains ONE result, it will remove the
array around it automatically.

```ruby
  divs_inside_proxy = ParserGirl.find(ANY_HTML, "div")
  divs_inside_proxy.content
  => ["First div content", "Second div content", ...]
  divs_inside_proxy.to_h
  => [{ :class => "div 1" }, ...]
  divs_inside_proxy[:class]
  => ["class of div1", "class of div2", nil, "class of div4"]
```

### Enumerating through results

```ruby
  divs_inside_proxy = ParserGirl.find(ANY_HTML, "div")
  only_divs = divs_inside_proxy.to_a

  divs_inside_proxy.reduce([]) do |acc, div|
    if div[:class].include?("btn")
      acc << div.find("a").first
    end
    next acc
  end
```

## Tests

Clone the repository, navigate into the root and execute this command:

```bash
  ruby -Ilib test/test_runner.rb
```
