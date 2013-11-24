module Mixingpanel

  module Security
    def self.allowed?(ip)
       not Rails.env.production? or 
          (Rails.env.production? and (allowed_ip?(ip) or temp_access?))
    end

    private
    def self.allowed_ip?(ip)
      return true if ENV['MIXPANEL_FILTERED_IPS'].nil?

      filtered_ips = ENV['MIXPANEL_FILTERED_IPS'].split(/[,;\| ]/).reject {|e| e.empty?}
      not filtered_ips.include?(ip)
    end

    def self.temp_access?
      ENV['MIXPANEL_TEMP_ACCESS'].to_s =~ /^true|yes|ok|1$/i
    end
  end

end