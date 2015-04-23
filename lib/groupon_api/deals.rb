module GrouponApi
  def self.deals(params)
    raise ::ArgumentError, 'param :ts_token cannot be nil' if GrouponApi.config.ts_token.nil?
    raise ::ArgumentError, 'param :ts_token must match /US_AFF_0_\d+_212556_0/' unless GrouponApi.config.ts_token.match(API_KEY_FORMAT)
    
    params.merge!(GrouponApi.config.deals)
    params.merge!(tsToken: GrouponApi.config.ts_token)
    
    GrouponApi::Request.call('deals', params)
  end
end