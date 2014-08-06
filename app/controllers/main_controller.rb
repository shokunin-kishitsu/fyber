class MainController < ApplicationController

  include MainHelper

  def get_offers
    uid = params[:uid]
    pub0 = params[:pub0]
    page = params[:page]

    response = request_offers(uid, pub0, page)
    parsed_json = JSON.parse(response.body)
    @offers = []

    bad_response = response.code != '200' || response.code == '200' && parsed_json['code'] == 'NO_CONTENT'

    flash[:notice] = parsed_json['message'] and return if bad_response
    flash[:notice] = 'Response is not authentic' and return if !is_authentic? response

    @offers = parse_offers(parsed_json['offers'])
  end

end
