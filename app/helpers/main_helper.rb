require 'net/http'
require 'digest/sha1'

module MainHelper

  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

  def request_offers uid, pub0, page
    query_string = generate_query_string(uid, pub0, page)
    uri = generate_uri(query_string)
    response = Net::HTTP.get_response(uri)
  end

  def is_authentic? response
    Digest::SHA1.hexdigest(response.body + API_KEY) == response.header['X-Sponsorpay-Response-Signature']
  end

  def parse_offers offers
    offers.map do |offer|
      Offer.new offer.merge({ 'thumbnail' => offer['thumbnail']['lowres'] })
    end
  end

  def generate_uri query_string
    URI("http://api.sponsorpay.com/feed/v1/offers.json?#{ query_string }&hashkey=#{ generate_hashkey(query_string) }")
  end

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
    query_string += '&' + API_KEY
    Digest::SHA1.hexdigest(query_string)
  end

end
