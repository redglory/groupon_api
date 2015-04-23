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
      url_str = "#{protocol}://#{API_BASE}/#{endpoint}.json?#{query_arr.join('&')}"
      begin
        result = Net::HTTP.get(URI.parse(url_str))
      rescue => e
        puts '[RESCUE]: ' + e.to_s
        return []
      end
      
      # return result as Array of HashWithIndifferentAccess
      json = JSON.parse(result)
      json['deals'].collect{|deal| HashWithIndifferentAccess.new(deal)}
    end
  end
end