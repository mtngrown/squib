require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1, layout: 'custom-layout.yml') do 
  background color: :white

  # Layouts are YAML files that specify x, y, width, and height coordinates
  rect layout: :frame

  # Other parameters can be used to override a given layout too
  rect layout: :frame, x: 150

  save_png prefix: 'layout_'
end