# frozen_string_literal: true

module Onebox
  module Engine
    class InstagramOnebox
      include Engine
      include StandardEmbed

      matches_regexp(/^https?:\/\/(?:www\.)?(?:instagram\.com|instagr\.am)\/?(?:.*)\/p\/[a-zA-Z\d_-]+/)
      always_https

      def clean_url
        url.scan(/^https?:\/\/(?:www\.)?(?:instagram\.com|instagr\.am)\/?(?:.*)\/p\/[a-zA-Z\d_-]+/).flatten.first
      end

      def to_html
        data
      end

      def data
        oembed = get_oembed
        oembed.html
      end

      protected

      def get_oembed_url
        oembed_url = "https://api.instagram.com/oembed/?url=#{clean_url}&omitscript=false"
      end
    end
  end
end
