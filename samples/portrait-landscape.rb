require 'squib'

# For decks with both landscape and portrait orientations,
# we recommend using two separate decks. 
# For print-on-demand, we can rotate all of the images in the final step.

# Normal cards
Squib::Deck.new(width: 825, height: 1125) do 
  background color: '#aaa'

  text str: "This is portrait"

  save_png prefix: "portrait_"
end

# Money cards are landscape
Squib::Deck.new(width: 1125, height: 825) do
  background color: '#aaa'

  text str: "This is landscape"

  save_png prefix: "landscape_", rotate: true
end