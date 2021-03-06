# frozen_string_literal: true

module Onebox
  module Engine
    class TwitterStatusOnebox
      include Engine
      include StandardEmbed

      matches_regexp(/^https?:\/\/(mobile\.|www\.)?twitter\.com/)
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
        oembed_url = "https://publish.twitter.com/oembed?url=#{clean_url}"
      end

      def add_stimulus_controller(html)
        return "" unless html
        '<div class="no-display tw-onebox" data-controller="twitter">' + html + '</div>'
      end
    end
  end
end
