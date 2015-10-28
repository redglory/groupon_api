require "net/http"
require "uri"
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module GrouponApi
  class Request
    def self.call(endpoint, params, iso_code="")
      # format query string
      query_arr = []
      params.each_pair do |key,val|
        query_arr << "#{key}=#{val}"
      end
      
      # Call API with config.use_ssl
      protocol = GrouponApi.config.use_ssl ? 'https' : 'http'
      query_str = query_arr.join('&')
      if endpoint == "countries"
        url_str = "#{protocol}://api.groupon.de/api/v1/#{endpoint}.json"
      elsif endpoint == "divisions"
        raise ::ArgumentError, 'param :iso_code cannot be nil' if (GrouponApi.config.iso_code.nil? && iso_code.empty?)
        # use iso_code parameter if present else use global GrouponApi.config.iso_code
        iso_code = !iso_code.empty? ? iso_code : GrouponApi.config.iso_code
        # load all countries
        countries = HashWithIndifferentAccess.new(YAML.load_file(File.join(File.dirname(__FILE__),"countries.yml")))
        if countries.has_key?(iso_code)
          url_str = "#{protocol}://#{countries[iso_code]}"
        else
          url_str = ""
        end
      else
        url_str = "#{protocol}://#{API_BASE}/#{endpoint}.json?#{query_str}"
      end
      
      # Only process valid API urls
      if url_str.present?
        if GrouponApi.config.use_proxy
  
          proxy_uri = URI.parse(ENV['http_proxy'])
          # set proxy variables
          proxy_user, proxy_pass = proxy_uri.userinfo.split(/:/) if proxy_uri.userinfo
  
          uri = URI.parse(url_str)
  
          puts "#{__FILE__}:#{__LINE__} url_str: #{url_str}" if GrouponApi.config.debug
          begin
            # build http with proxy
            http = Net::HTTP.start(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_user, proxy_pass, :use_ssl => uri.scheme == 'https')
            request = Net::HTTP::Get.new(uri.request_uri)
            # retrieve response
            response = http.request(request)
            # Finish HTTP connection.
            http.finish if http.started?  
          rescue => e
            puts "#{__FILE__}:#{__LINE__} [RESCUE]: #{e}" if GrouponApi.config.debug
            response = e
          end
          
        else
          puts "#{__FILE__}:#{__LINE__} url_str: #{url_str}" if GrouponApi.config.debug
          begin
            response = Net::HTTP.get(URI.parse(url_str))
          rescue => e
            puts "#{__FILE__}:#{__LINE__} [RESCUE]: #{e}" if GrouponApi.config.debug
            response = e 
          end
        end
        
        # return response as Array of HashWithIndifferentAccess
        case response
          when Net::HTTPSuccess
            json = JSON.parse(response.body)
            puts "#{__FILE__}:#{__LINE__} json:" if GrouponApi.config.debug
            puts "#{json}" if GrouponApi.config.debug
            json
          when Net::HTTPUnauthorized
            puts "#{response.message}: username and password set and correct?" if GrouponApi.config.debug
            {'error' => "#{response.message}: username and password set and correct?"}
          when Net::HTTPServerError
            puts "#{response.message}: try again later?" if GrouponApi.config.debug
            {'error' => "#{response.message}: try again later?"}
          else
            puts "#{response.message}" if GrouponApi.config.debug
            response = {'error' => e.message}
        end
      else
        puts "Countries.yml has no API url for country #{iso_code}! Update it!" if GrouponApi.config.debug
        return {'error' => "Countries.yml has no API url for country #{iso_code}! Update it!"}
      end
    end

    #------------------------------------------------------------------------------------
    # Country               ISO Code  Division API (Cities)
    #------------------------------------------------------------------------------------
    # Argentina             AR        http://api.groupon.de/api/v1/cities/AR.json
    # Austria               AT        http://api.groupon.de/api/v1/cities/AT.json
    # Australia             AU        http://api-asia.groupon.de/api/mobile/au/divisions
    # Belgium               BE        http://api.groupon.de/api/v1/cities/BE.json
    # Brazil                BR        http://api.groupon.de/api/v1/cities/BR.json
    # Denmark               DK        http://api.groupon.de/api/v1/cities/DK.json
    # Finland               FI        http://api.groupon.de/api/v1/cities/FI.json
    # France                FR        http://api.groupon.de/api/v1/cities/FR.json
    # Germany               DE        http://api.groupon.de/api/v1/cities/DE.json
    # Greece                GR        http://api.groupon.de/api/v1/cities/GR.json
    # India                 IN        http://api.groupon.co.in/api/mobile/in/divisions
    # Ireland               IE        http://api.groupon.de/api/v1/cities/IE.json
    # Israel                IL        http://api.groupon.de/api/v1/cities/IL.json
    # Italy                 IT        http://api.groupon.de/api/v1/cities/IT.json
    # Malaysia              MY        http://api-asia.groupon.de/api/mobile/my/divisions
    # Netherlands           NL        http://api.groupon.de/api/v1/cities/NL.json
    # New Zealand           NZ        http://api-asia.groupon.de/api/mobile/nz/divisions
    # Norway                NO        http://api.groupon.de/api/v1/cities/NO.json
    # Philippines           PH        http://api-asia.groupon.de/api/mobile/ph/divisions
    # Portugal              PT        http://api.groupon.de/api/v1/cities/PT.json
    # Romania               RO        http://api.groupon.de/api/v1/cities/RO.json
    # Singapore             SG        http://api-asia.groupon.de/api/mobile/sg/divisions
    # South Africa          ZA        http://api.groupon.de/api/v1/cities/ZA.json
    # Spain                 ES        http://api.groupon.de/api/v1/cities/ES.json
    # Sweden                SE        http://api.groupon.de/api/v1/cities/SE.json
    # Switzerland           CH        http://api.groupon.de/api/v1/cities/CH.json
    # Thailand              TH        http://api-asia.groupon.de/api/mobile/th/divisions
    # Turkey                TR        http://api.groupon.de/api/v1/cities/TR.json
    # United Arab Emirates  AE        http://api.groupon.de/api/v1/cities/AE.json
    # United Kingdom        UK        http://api.groupon.de/api/v1/cities/UK.json
    #-----------------------------------------------------------------------------------    
  end
end