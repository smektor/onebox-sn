# frozen_string_literal: true

module Onebox
  module Engine
    class TwitterStatusOnebox
      include Engine
      include StandardEmbed

      matches_regexp(/^https?:\/\/(mobile\.|www\.)?twitter\.com\/.+?\/status(es)?\/\d+(\/(video|photo)\/\d?+)?+(\/?\?.*)?\/?$/)
      always_https

      def clean_url
        # TODO
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
        oembed_url = "https://publish.twitter.com/oembed?url=#{clean_url}"
      end

      def add_stimulus_controller(html)
        '<div class="no-display" data-controller="twitter">' + html + '</div>'
      end
    end
  end
end
