require "net/http"
require "uri"
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module GrouponApi
  class Request
    def self.call(endpoint, params)
      # format query string
      query_arr = []
      params.each_pair do |key,val|
        query_arr << "#{key}=#{val}"
      end
      
      # Call API with config.use_ssl
      protocol = GrouponApi.config.use_ssl ? 'https' : 'http'
      query_str = query_arr.join('&')
      url_str = "#{protocol}://#{API_BASE}/#{endpoint}.json?#{query_str}"
      puts "#{__FILE__}:#{__LINE__} url_str: #{url_str}" if GrouponApi.config.debug
      begin
        result = Net::HTTP.get(URI.parse(url_str))
      rescue => e
        puts "#{__FILE__}:#{__LINE__} [RESCUE]: #{e}" if GrouponApi.config.debug
        return []
      end
      
      # return result as Array of HashWithIndifferentAccess
      json = JSON.parse(result)
      puts "#{__FILE__}:#{__LINE__} json:" if GrouponApi.config.debug
      puts "#{json}" if GrouponApi.config.debug
      json['deals'].collect{|deal| HashWithIndifferentAccess.new(deal)}
    end
  end
end