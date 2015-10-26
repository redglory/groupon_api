require "groupon_api/version"
require 'groupon_api/config'
require "groupon_api/deals"
require "groupon_api/request"

module GrouponApi
  API_KEY_FORMAT = /US_AFF_0_\d+_212556_0/
  API_BASE = !GrouponApi.config.use_int ? 'partner-api.groupon.com' : 'partner-int-api.groupon.com'
end
