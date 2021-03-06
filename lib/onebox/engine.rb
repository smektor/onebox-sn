# frozen_string_literal: true

module Onebox
  module Engine
    def self.included(object)
      object.extend(ClassMethods)
    end

    def self.engines
      constants.select do |constant|
        constant.to_s =~ /Onebox$/
      end.map(&method(:const_get))
    end

    attr_reader :url, :uri
    attr_reader :timeout

    DEFAULT = {}
    def options
      @options
    end

    def options=(opt)
      return @options if opt.nil? #make sure options provided
      opt = opt.to_h  if opt.instance_of?(OpenStruct)
      @options.merge!(opt)
      @options
    end

    def initialize(link, timeout = nil)
      @options = DEFAULT
      class_name = self.class.name.split("::").last.to_s

      # Set the engine options extracted from global options.
      self.options = Onebox.options[class_name] || {}

      @url = link
      @link = link
      @uri = ::Onebox::Helpers.get_uri(link)
      if always_https?
        @uri.scheme = 'https'
        @url = @uri.to_s
      end
      @timeout = timeout || Onebox.options.timeout
    end

    # raises error if not defined in onebox engine.
    # This is the output method for an engine.
    def to_html
      fail NoMethodError, "Engines need to implement this method"
    end

    # Some oneboxes create iframes or other complicated controls. If you're using
    # a live editor with HTML preview, rendering those complicated controls can
    # be slow or cause flickering.
    #
    # This method allows engines to produce a placeholder such as static image
    # frame of a video.
    #
    # By default it just calls `to_html` unless implemented.
    def placeholder_html
      to_html
    end

    private

    # raises error if not defined in onebox engine
    # in each onebox, uses either Nokogiri or StandardEmbed to get raw HTML from url
    def raw
      fail NoMethodError, "Engines need to implement this method"
    end

    # raises error if not defined in onebox engine
    # in each onebox, returns hash of desired onebox content
    def data
      fail NoMethodError, "Engines need this method defined"
    end

    def link
      ::Onebox::Helpers.uri_encode(@url)
    end

    def always_https?
      self.class.always_https?
    end

    module ClassMethods
      def ===(other)
        if other.kind_of?(URI)
          !!(other.to_s =~ class_variable_get(:@@matcher))
        else
          super
        end
      end

      def priority
        100
      end

      def matches_regexp(r)
        class_variable_set :@@matcher, r
      end

      # calculates a name for onebox using the class name of engine
      def onebox_name
        name.split("::").last.downcase.gsub(/onebox/, "")
      end

      def always_https
        @https = true
      end

      def always_https?
        @https
      end
    end
  end
end

require_relative "helpers"
require_relative "layout_support"
require_relative "file_type_finder"
require_relative "engine/standard_embed"
require_relative "engine/html"
require_relative "engine/json"
require_relative "engine/image_onebox"
require_relative "engine/video_onebox"
require_relative "engine/twitter_status_onebox"
require_relative "engine/youtube_onebox"
require_relative "engine/whitelisted_generic_onebox"
require_relative "engine/vimeo_onebox"
require_relative "engine/instagram_onebox"
require_relative "engine/facebook_media_onebox"
