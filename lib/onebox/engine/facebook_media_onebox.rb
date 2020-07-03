# frozen_string_literal: true

module Onebox
  module Engine
    class FacebookMediaOnebox
      include Engine
      include StandardEmbed

      matches_regexp(/^https?:\/\/.*\.facebook\.com/)
      always_https

      def clean_url
        url
      end

      def to_html
        data
      end

      def data
        oembed = get_oembed
        add_stimulus_controller(oembed.html)
      end

      protected

      def get_oembed_url
        if /^https?:\/\/www\.facebook\.com\/.*?video(?:s|\.php.*?[?&](?:id|v)=)\/?([^\/&\n]+).*$/.match?(url)
          oembed_url = "https://www.facebook.com/plugins/video/oembed.json/?url=#{clean_url}"
        else
          oembed_url = "https://www.facebook.com/plugins/post/oembed.json/?url=#{clean_url}"
        end
      end

      def add_stimulus_controller(html)
        '<div class="no-display" data-controller="facebook">' + html + '</div>'
      end
    end
  end
end
