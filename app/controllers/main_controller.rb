require 'net/http'
require 'digest/sha1'

class MainController < ApplicationController

  include MainHelper

  def get_offers
    uid = params[:uid]
    pub0 = params[:pub0]
    page = params[:page]

    query_string = generate_query_string(uid, pub0, page)

    uri = URI("http://api.sponsorpay.com/feed/v1/offers.json?#{ query_string }&hashkey=#{ generate_hashkey(query_string) }")
    response = Net::HTTP.get_response(uri)
    signature = response.header['X-Sponsorpay-Response-Signature']

    @offers = []

    parsed_json = JSON.parse(response.body)
    if response.code == '200' && parsed_json['code'] == 'NO_CONTENT'
      if generate_response_signature(response.body) != signature
        flash[:notice] = 'Response is not authenticated'
      else
        parsed_json['offers'] = [
          {'title' => 'THE TITLE', 'payout' => 'THE PAYOUT', 'thumbnail' => {'lowres' => 'http://cache.graphicslib.viator.com/graphicslib/thumbs674x446/5550/SITours/4-day-south-portugal-tour-from-lisbon-lagos-algarve-coast-sagres-vora-in-lisbon-138295.jpg', 'hires' => 'WRONG'}},
          {'title' => 'THE TITLE2', 'payout' => 'THE PAYOUT2', 'thumbnail' => {'lowres' => 'http://www.bookableholidays.com/images/country/portugal/algarve/lagos/sandy-beach-in-lagos.jpg', 'hires' => 'WRONG2'}}
        ]

        json_offers = parsed_json['offers'].map {|offer| offer.merge({ 'thumbnail' => offer['thumbnail']['lowres'] }) }

        json_offers.each do |offer|
          @offers << Offer.new(offer)
        end
      end
    else
      flash[:notice] = parsed_json['message']
    end
  end

end
