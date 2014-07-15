require 'andyexample'

describe Andy::TestDeck do   

  it "initializes with default parameters" do
    d = Andy::TestDeck.new 
    expect(d.width).to eq(825)
    expect(d.height).to eq(1125)
    expect(d.cards.size).to eq(1)
  end

  it "calls draw_text on two cards" do
    card1 = instance_double(Andy::TestCard)
    card2 = instance_double(Andy::TestCard)
    expect(card1).to receive(:draw_text).once
    expect(card2).to receive(:draw_text).once
    Andy::TestDeck.new do  
      @cards = [card1, card2]  
      text
    end
  end  

end#describe

