# frozen_string_literal: true

module Onebox
  module Engine
    class AudioOnebox
      include Engine

      matches_regexp(/^(https?:)?\/\/.*\.(mp3|ogg|opus|wav|m4a)(\?.*)?$/i)

      def always_https?
        WhitelistedGenericOnebox.host_matches(uri, WhitelistedGenericOnebox.https_hosts)
      end

      def to_html
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(@link)

        <<-HTML
          <audio controls autoplay name="media">
            <source src="#{@link}" type="audio/mpeg">
          </audio>
        HTML
      end

      def placeholder_html
        ::Onebox::Helpers.audio_placeholder_html
      end
    end
  end
end
