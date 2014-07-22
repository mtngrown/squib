module Squib
  class Deck
    
    # Draw a rounded rectangle
    #
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param width: the width of the rectangle.
    # @param height: the height of the rectangle.
    # @param layout: set a custom layout for x,y,width,height. See See {file:API.md#label-Custom+Layouts Custom Layouts}
    # @param x_radius: the radius of the rounded corner horiztonally. Zero is a non-rounded corner.
    # @param y_radius: the radius of the rounded corner vertically. Zero is a non-rounded corner.
    # @param radius: when set, overrides both x_radius and y_radius
    # @param fill_color: the color with which to fill the rectangle
    # @param stroke_color: the color with which to stroke the outside of the rectangle
    # @param stroke_width: the width of the outside stroke
    # @api public
    def rect(p = {})
      p = layoutify(p)
      defaults = {range: :all, x: 0, y: 0, width: 825, height: 1125, layout: nil, 
              radius: nil, x_radius: 0, y_radius: 0, 
              fill_color: '#0000', stroke_color: :black, stroke_width: 2.0}
      p = defaults.merge(p)
      range = rangeify(p[:range])
      fill_color = colorify(p[:fill_color])
      stroke_color = colorify(p[:stroke_color])
      stroke_width = p[:stroke_width]
      x_radius,y_radius = radiusify(p[:radius], p[:x_radius], p[:y_radius])
      x,y,width,height = p[:x], p[:y], p[:width], p[:height]
      range.each do |i|
        @cards[i].draw_rectangle(x, y, width, height, x_radius, y_radius, fill_color, stroke_color, stroke_width)
      end
    end
    
  end
end