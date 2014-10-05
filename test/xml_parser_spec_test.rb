HTML = <<EOF.gsub(/[\n\r]/, '')
<body>
  <div class="btn zort" id="troz">
    <i>The pinky and the brain</i>
  </div>
  <div class="cage">
    The cage
  </div>
</body>
EOF

describe ParserGirl::Parser do
  describe "parse simple html" do
    before do
      @pg = ParserGirl.new(HTML)
    end

    after do
      @pg = nil
    end

    it "should find the <i> tag when searching for i and nothing else" do
      assert_equal "The pinky and the brain", @pg.find("i").content
    end

    it "should find both <div> tags when searching for them" do
      assert_equal 2, @pg.find("div").size
    end

    it "should be capable of enumerating the result for <div> tags" do
      assert @pg.find("div").map.is_a?(Enumerable)
    end

    it "should parse the attributes of the <div> tags correctly" do
      assert_equal({ :class => "btn zort", :id => "troz" },
        @pg.find("div").to_h.first)
    end

    it "should make the attributes accessible through hash bracket accessors" do
      assert_equal "btn zort", @pg.find("div")[:class].first
    end

    it "should make the resultset accessible through to_a" do
      assert @pg.find("div").to_a.is_a?(Array)
    end
  end

  describe "parse through html trees" do
    it "should find the <i> tag inside the <div> tags" do
      result = ParserGirl.find(HTML, "div").reduce([]) do |acc, divs|
        i = divs.find("i").content if divs[:class].include?("zort")
        acc << i if i
        next acc
      end
      assert_equal "The pinky and the brain", result.first
    end
  end
end
