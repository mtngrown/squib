module Squib
  module InputHelpers

    def rangeify (range)
      raise 'Range cannot be nil' if range.nil?
      range = 0..(@cards.size-1) if range == :all
      range = range..range if range.is_a? Integer
      if range.max > (@cards.size-1)
        raise "#{range} is outside of deck range of 0..#{@cards.size-1}"
      end
      return range
    end
    module_function :rangeify

    def fileify(file)
      raise "File #{File.expand_path(file)} does not exist!" unless File.exists? file
      file
    end
    module_function :fileify

    def dirify(dir, allow_create: false)
      return dir if Dir.exists? dir 
      if allow_create
        Squib.logger.warn "PDF output dir #{dir} does not exist... attempting to create it"
        Dir.mkdir dir
        return dir 
      else
        raise "#{dir} does not exist!"
      end
    end
    module_function :dirify


    def colorify(color, nillable: false)
      if nillable # for optional color arguments like text hints
        color = Cairo::Color.parse(color) unless color.nil?
      else
        color ||= :black
        color = Cairo::Color.parse(color)
      end
      color
    end
    module_function :colorify

    def fontify (font)
      font = @font if font==:use_set
      font = Squib::DEFAULT_FONT if font==:default
      font 
    end
    module_function :fontify 

    def radiusify(radius, x_radius, y_radius)
      if radius.nil?
        return x_radius, y_radius
      else 
        return radius,radius
      end
    end
    module_function :radiusify

    def layoutify(p)
      entry = p[:layout].to_s
      if entry.nil? #no layout was specified
        return p[:x], p[:y], p[:width], p[:height]
      else
        [:x, :y, :width, :height].each do |coord|
          p[coord] ||= @layout[entry][coord.to_s] unless @layout[entry][coord.to_s].nil?
        end
        return p
      end
    end
    module_function :layoutify

    def xyify
      #TODO: Allow negative numbers that subtract from the card width & height
    end

  end
end