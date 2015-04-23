require 'spec_helper'

describe GrouponApi do
  
  shared_context :without_api_key do
    before do
      GrouponApi.config.ts_token = nil
    end
  end
  shared_context :invalid_api_key do
    before do
      GrouponApi.config.ts_token = 42
    end
  end
  shared_context :valid_api_key do
    before do
      GrouponApi.config.ts_token = your_ts_token
    end
  end
  
  describe '.deals' do
    let(:valid_params){
      {
        lat: 40.704235,
        lng: -73.986797,
        radius: 10
      }
    }
    context 'without API key' do
      include_context :without_api_key
      it "throws an exception" do
        expect{described_class.deals(valid_params)}.to raise_error(ArgumentError, 'param :ts_token cannot be nil')
      end
    end
    context 'with invalid API key' do
      include_context :invalid_api_key
      it 'throws an exception' do
        expect{described_class.deals(valid_params)}.to raise_error
      end
    end
    context 'with valid API key' do
      include_context :valid_api_key
      context 'without results' do
        it 'returns an empty Array' do
          params = valid_params.merge(limit: 0, offset: 0)
          result = described_class.deals(params)
          expect(result).to be_a(Array)
          expect(result.size).to eq(0)
        end  
      end
      context 'with results' do  
        it "returns an Array of Hashes" do
          result = described_class.deals(valid_params)
          expect(result).to be_a(Array)
          expect(result.first).to be_a(HashWithIndifferentAccess)
        end
      end
    end    
  end #deals
  
  describe '.divisions' do
    pending
  end #divisions
  
end
