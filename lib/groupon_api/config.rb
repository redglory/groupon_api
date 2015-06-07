require 'active_support/configurable'

module GrouponApi
  # configure GrouponApi global settings
  #   GrouponApi.configure do |config|
  #     config.ts_token = 'US_AFF_0_201236_212556_0'
  #     config.debug = true
  #   end
  def self.configure &block
    yield @config ||= GrouponApi::Configuration.new
  end

  # GrouponApi global settings
  def self.config
    @config ||= GrouponApi::Configuration.new
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:ts_token){ nil }
    config_accessor(:use_ssl){ true }
    config_accessor(:debug){ false }
    
    #deals
    config_accessor(:deals){ {} }
  end
end