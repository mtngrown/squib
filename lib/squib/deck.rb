require 'yaml'
require 'pp'
require 'squib'
require 'squib/card'
require 'squib/progress'
require 'squib/input_helpers'
require 'squib/constants'

# The project module
#
# @api public
module Squib

  # The main interface to Squib. Provides a front-end porcelain whereas the Card class interacts with the graphics plumbing.
  #
  # @api public
  class Deck
    include Enumerable
    include Squib::InputHelpers

    # :nodoc:
    # @api private
    attr_reader :width, :height

    # :nodoc:
    # @api private
    attr_reader :cards

    # :nodoc:
    # @api private
    attr_reader :text_hint

    # :nodoc:
    # @api private
    attr_reader :layout, :config

    # Squib's constructor that sets the immutable properties.
    #
    # This is the starting point for Squib. In providing a block to the constructor, you have access to all of Deck's instance methods.
    # The documented methods in Deck are the ones intended for use by most users.
    # If your game requires multiple different sizes or orientations, I recommend using multiple `Squib::Deck`s in your `deck.rb`. You can modify the internals of `Squib::Deck` (e.g. `@cards`), but that's not recommended.
    # @example
    #   require 'squib'
    #   Squib::Deck.new do
    #     text str: 'Hello, World!"
    #   end
    #
    # @param width [Integer] the width of each card in pixels
    # @param height [Integer] the height of each card in pixels
    # @param cards [Integer] the number of cards in the deck
    # @param dpi [Integer] the pixels per inch when rendering out to PDF or calculating using inches.
    # @param config [String] the file used for global settings of this deck
    # @param layout [String, Array] load a YML file of custom layouts. Multiple files are merged sequentially, redefining collisons. See README and sample for details.
    # @param block [Block] the main body of the script.
    # @api public
    def initialize(width: 825, height: 1125, cards: 1, dpi: 300, config: 'config.yml', layout: nil, &block)
      @width=width; @height=height
      @dpi = dpi
      @font = Squib::SYSTEM_DEFAULTS[:default_font]
      @cards = []
      @custom_colors = {}
      @img_dir = '.'
      @progress_bar = Squib::Progress.new(false)
      @text_hint = :off
      cards.times{ @cards << Squib::Card.new(self, width, height) }
      show_info(config, layout)
      load_config(config)
      load_layout(layout)
      if block_given?
        instance_eval(&block)
      end
    end

    # Directly accesses the array of cards in the deck
    #
    # @api private
    def [](key)
      @cards[key]
    end

    # Iterates over each card in the deck
    #
    # @api private
    def each(&block)
      @cards.each { |card| block.call(card) }
    end

    # Shows a descriptive place of the location
    #
    # @api private
    def location(opts)
      opts[:layout] || (" @ #{opts[:x]},#{opts[:y]}")
    end

    # Load the configuration file, if exists, overriding hardcoded defaults
    # @api private
    def load_config(file)
      if File.exists?(file) && config = YAML.load_file(file)
        Squib::logger.info { "  using config: #{file}" }
        config = Squib::CONFIG_DEFAULTS.merge(config)
        @dpi = config['dpi'].to_i
        @text_hint = config['text_hint']
        @progress_bar.enabled = config['progress_bars']
        @custom_colors = config['custom_colors']
        @img_dir = config['img_dir']
      end
    end

    # Load the layout configuration file, if exists
    # @api private
    def load_layout(files)
      @layout = {}
      Squib::logger.info { "  using layout(s): #{files}" }
      Array(files).each do |file|
        thefile = file
        thefile = "#{File.dirname(__FILE__)}/layouts/#{file}" unless File.exists?(file)
        if File.exists? thefile
          yml = @layout.merge(YAML.load_file(thefile) || {}) #load_file returns false on empty file
          yml.each do |key, value|
            @layout[key] = recurse_extends(yml, key, {})
          end
        else
          puts "the file: #{thefile}"
          Squib::logger.error { "Layout file not found: #{file}" }
        end
      end
    end

    # Process the extends recursively
    # :nodoc:
    # @api private
    def recurse_extends(yml, key, visited )
      assert_not_visited(key, visited)
      return yml[key] unless has_extends?(yml, key)
      visited[key] = key
      parent_keys = [yml[key]['extends']].flatten
      h = {}
      parent_keys.each do |parent_key|
        from_extends = yml[key].merge(recurse_extends(yml, parent_key, visited)) do |key, child_val, parent_val|
          if child_val.to_s.strip.start_with?('+=')
            parent_val + child_val.sub('+=','').strip.to_f
          elsif child_val.to_s.strip.start_with?('-=')
            parent_val - child_val.sub('-=','').strip.to_f
          else
            child_val #child overrides parent when merging, no +=
          end
        end
        h = h.merge(from_extends) do |key, older_sibling, younger_sibling|
          younger_sibling #when two siblings have the same entry, the "younger" (lower one) overrides
        end
      end
      return h
    end

    # Does this layout entry have an extends field?
    # i.e. is it a base-case or will it need recursion?
    # :nodoc:
    # @api private
    def has_extends?(yml, key)
      !!yml[key] && yml[key].key?('extends')
    end

    # Safeguard against malformed circular extends
    # :nodoc:
    # @api private
    def assert_not_visited(key, visited)
      if visited.key? key
        raise "Invalid layout: circular extends with '#{key}'"
      end
    end

    # Use Logger to show more detail on the run
    # :nodoc:
    # @api private
    def show_info(config, layout)
      Squib::logger.info "Squib v#{Squib::VERSION}"
      Squib::logger.info "  building #{@cards.size} #{@width}x#{@height} cards"
    end

    ##################
    ### PUBLIC API ###
    ##################
    require 'squib/api/background'
    require 'squib/api/data'
    require 'squib/api/image'
    require 'squib/api/save'
    require 'squib/api/settings'
    require 'squib/api/shapes'
    require 'squib/api/text'
    require 'squib/api/units'

  end
end
