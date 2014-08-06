require 'test_helper'

class OfferTest < ActionView::TestCase

  context 'valid Offer model' do

    should 'have title, payout, and thumbnail' do
      offer = Offer.new(title: 'Valid title', payout: '200', thumbnail: 'placeholder_url')
      assert offer.valid?

      offer = Offer.new(payout: '200', thumbnail: 'placeholder_url')
      refute offer.valid?, 'does not have title'

      offer = Offer.new(title: 'Valid title', thumbnail: 'placeholder_url')
      refute offer.valid?, 'does not have payout'

      offer = Offer.new(title: 'Valid title', payout: '200')
      refute offer.valid?, 'does not have thumbnail'
    end

  end
end
