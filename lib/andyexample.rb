### FIXME remove these once the production code is more stable

module Andy

  class TestDeck
    attr_reader :width, :height, :cards

    def initialize(width: 825, height: 1125, cards: 1, &block)
      @width=width; @height=height
      @cards = []
      cards.times{@cards << TestCard.new}
      if block_given?
        instance_eval(&block)    
      end
    end

    def text
      @cards.each {|c| c.draw_text}      
    end

  end

  class TestCard
    def draw_text
      puts "Drawn text!"
    end
  end

end
