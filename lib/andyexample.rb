### FIXME remove these once the production code is more stable

module Andy

  class TestDeck
    attr_reader :width, :height, :cards

    def initialize(width: 825, height: 1125, cards: 1, &block)
      @width=width; @height=height
      @cards = []
      cards.times{@cards << TestCard.new(width,height)}
      if block_given?
        instance_eval(&block)    
      end
    end

    def text(range: :all, str: '')
      range=(0..@cards.size-1) if range==:all
      range=range..range unless range.respond_to? :each
      range.each { |i| @cards[i].draw_text(str) }
    end

  end

  class TestCard
    def initialize(width, height)
    end

    def draw_text(str)
      str
    end
  end

end
