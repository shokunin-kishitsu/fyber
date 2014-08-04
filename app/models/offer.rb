require 'active_model'

class Offer
  include ActiveModel::Model

  attr_accessor :title, :payout, :thumbnail
end
