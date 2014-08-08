require 'test_helper'

class MainControllerTest < ActionController::TestCase

  include MainHelper

  should 'get index' do
    get :index
    assert_response :success
  end

  context 'get_offers' do

    setup do
      WebMock.disable_net_connect!
    end

    should 'make a request to the API' do
      stub_api_request

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert_response :success
      assert assigns(:offers)
    end

    should 'inform user if JSON is incorrectly formatted' do
      stub_api_request 200, 'bad JSON'

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert flash[:notice] == "Can\'t parse JSON"
    end

    should 'inform user if response status code is not 200' do
      stub_api_request 401, "{\"code\":\"UNAUTHORIZED\",\"message\":\"Sorry, but request was not authorized.\"}"

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert flash[:notice] == "Sorry, but request was not authorized."
    end

    should 'inform user if there is no content' do
      stub_api_request 200, "{\"code\":\"NO_CONTENT\",\"message\":\"The request was successful, but there is no content.\"}"

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert flash[:notice] == "The request was successful, but there is no content."
    end

    should 'inform user if the request was not authentic' do
      stub_api_request 200, "{\"code\":\"SUCCESS\",\"message\":\"Successful request.\"}", {'X-Sponsorpay-Response-Signature' => 'bad signature'}

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert flash[:notice] == "Response is not authentic"
    end

    should 'assign exact number of offers as in the response' do
      response_body = {
        "code" => "SUCCESS",
        "message" => "Successful request.",
        "offers" => [
          {
            "title" => "TITLE1",
            "payout" => "100",
            "thumbnail" => {
              "hires" => "hires_url",
              "lowres" => "lowres_url"
            }
          },
          {
            "title" => "TITLE2",
            "payout" => "200",
            "thumbnail" => {
              "hires" => "hires_url2",
              "lowres" => "lowres_url2"
            }
          }
        ]
      }.to_json
      signature = generate_signature(response_body)
      stub_api_request 200, response_body, {'X-Sponsorpay-Response-Signature' => signature}

      post :get_offers, { uid: 'uid', pub0: 'pub0', page: '1' }
      assert assigns(:offers).size == 2, flash[:notice].inspect
    end

  end

end
