require 'active_model'

class Offer
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :title, :payout, :thumbnail

  validates_presence_of :title, :payout, :thumbnail
end
