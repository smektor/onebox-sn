# frozen_string_literal: true

module Onebox
  class Matcher
    def initialize(link)
      @url = link
    end

    def ordered_engines
      @ordered_engines ||= Engine.engines.sort_by do |e|
        e.respond_to?(:priority) ? e.priority : 100
      end
    end

    def oneboxed
      begin
        uri = URI.parse(@url)
      rescue URI::InvalidURIError
        uri = URI.parse(URI.escape(@url))
      end

      return unless uri.port.nil? || Onebox.options.allowed_ports.include?(uri.port)
      return unless uri.scheme.nil? || Onebox.options.allowed_schemes.include?(uri.scheme)
      ordered_engines.find { |engine| engine === uri }
    end
  end
end
