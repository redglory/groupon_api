# GrouponApi

Groupon API gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'groupon_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install groupon_api

## Usage

### Authorization

You must have an active partner account to use this gem.

Apply here: https://partner.groupon.com

### Configuration

For most method calls GrouponApi must be configured with your partner tsToken, which you can set as such:

	GrouponApi.configure do |config|
	  config.ts_token = 'US_AFF_0_201236_212556_0'
	end

Additionally you can set default params per API call

	GrouponApi.configure do |config|
	  config.deals = {show: 'name,lat,lng', hide: 'areas,timezone,timezoneOffsetInSeconds'}
	end
	
Ad hoc configuration can be done with the ```.config``` method:

	GrouponApi.config.use_ssl = true #default, will use https instead of http
	
### Deals
Find Groupon deals with the ```.deals``` method.

	deals = GrouponApi.deals(params)
	deals[0] #HashWithIndifferentAccess
	
Your ```:ts_token``` will be automatically applied as well as any other default params set in ```config.deals```
	
A full list of parameters may be found here: https://partner-api.groupon.com/help/deal-api

## Testing

Since Groupon does not provide a test API enpoint / account, you must use your partner account
for testing.

Simply change the return value of ```#your_ts_token``` in ```spec/spec_helper.rb```

## Contributing

1. Fork it ( https://github.com/minerva-group/groupon_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add needed specs & code implementation
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
