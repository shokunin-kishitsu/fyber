ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

WebMock.disable_net_connect!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  def stub_api_request status = 200, response_body = '', response_headers = {}
    stub_request(:get, /api\.sponsorpay\.com\/feed\/v1\/offers\.json.*/).to_return(status: status, body: response_body, headers: response_headers)
  end

end
