require 'test_helper'

class MainControllerTest < ActionController::TestCase

  should 'get index' do
    get :index
    assert_response :success
  end

  context 'get_offers' do

    should 'make a request to the API' do
      WebMock.disable_net_connect!

      stub_api_request

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert_response :success
    end

  end

  private

  def stub_api_request response_body = '', response_headers = {}
    stub_request(:get, "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&hashkey=0b23a2436d2eebdf09ac8dc303e0a294874d2c4a&ip=109.235.143.113&locale=de&offer_types=112&page=1&pub0=pub0&timestamp=1407362925&uid=uid").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => response_headers)
  end

end
