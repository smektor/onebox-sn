# frozen_string_literal: true

module Onebox
  module Engine
    class VideoOnebox
      include Engine

      matches_regexp(/^(https?:)?\/\/.*\.(mov|mp4|webm|ogv)(\?.*)?$/i)

      def always_https?
        WhitelistedGenericOnebox.host_matches(uri, WhitelistedGenericOnebox.https_hosts)
      end

      def to_html
        # Fix Dropbox image links
        if @url[/^https:\/\/www.dropbox.com\/s\//]
          @url.sub!("https://www.dropbox.com", "https://dl.dropboxusercontent.com")
        end

        escaped_url = ::Onebox::Helpers.normalize_url_for_output(@url)
        <<-HTML
          <div class="onebox video-onebox">
            <video controls name="media">
              <source src='#{@link}' type="video/mp4">
            </video>
          </div>
        HTML
      end

      def placeholder_html
        ::Onebox::Helpers.video_placeholder_html
      end
    end
  end
end
