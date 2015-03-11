require 'json'

module Mixingpanel
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # See https://mixpanel.com/help/reference/javascript-full-api-reference#mixpanel.set_config
  # There you'll find all the default values and what does they mean!
  class Configuration
    attr_accessor :cross_subdomain_cookie,
                  :cookie_name,
                  :cookie_expiration,
                  :track_pageview,
                  :track_links_timeout,
                  :disable_cookie,
                  :secure_cookie,
                  :upgrade

    def to_hash
      key_values = instance_variables.map do |key|
        value = instance_variable_get(key)
        next if value.nil?
        [key[1..-1].to_sym, value]
      end

      Hash[key_values]
    end

    def to_json
      JSON.generate self.to_hash
    end

    def to_s
      self.to_hash.to_s
    end

  end
  
end
