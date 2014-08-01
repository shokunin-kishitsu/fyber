require 'net/http'
require 'digest/sha1'

class MainController < ApplicationController

  def get_offers
    uid = params[:uid]
    pub0 = params[:pub0]
    page = params[:page]

    query_string = generate_query_string(uid, pub0, page)

    uri = URI("http://api.sponsorpay.com/feed/v1/offers.json?#{ query_string }&hashkey=#{ generate_hashkey(query_string) }")
    response = JSON.parse(Net::HTTP.get_response(uri).body)

    puts Net::HTTP.get_response(uri).body
    @offers = []
  end

  private

  def generate_query_string uid, pub0, page
    parameters = {
      uid: uid,
      pub0: pub0,
      page: page,
      appid: 157,
      ip: '109.235.143.113',
      locale: 'de',
      device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
      offer_types: 112,
      timestamp: Time.now.to_i
    }
    parameters.sort.to_a.map {|tuple| "#{tuple[0]}=#{tuple[1]}" }.join('&')
  end

  def generate_hashkey query_string
    api_key = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
    query_string += '&' + api_key
    Digest::SHA1.hexdigest(query_string)
  end

end
