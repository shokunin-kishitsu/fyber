require 'test_helper'

class MainHelperTest < ActionView::TestCase

  context 'parse_offers' do

    should 'return an array of Offer models' do
      json_offers = [
        {'title' => 'Some title',
          'payout' => '100',
          'thumbnail' => {'lowres' => 'lowresimg', 'hires' => 'hiresimg'}},
        {'title' => 'Some title 2',
          'payout' => '200',
          'thumbnail' => {'lowres' => 'lowresimg2', 'hires' => 'hiresimg2'}}]
      offers = parse_offers(json_offers)
      offers.each {|offer| assert offer.is_a?(Offer), 'an offer is not an instance of Offer' }
    end

  end

  context 'request_offers' do

    should 'make a get request' do
      stub_api_request
      request_offers('uid', 'pub0', '1')
    end

  end

end
