require 'rails_helper'

RSpec.describe Amount, type: :model do
  let(:amount) { create(:amount) }

  describe "attributes" do
    it "has amount and default" do
      expect(amount).to have_attributes(amount: amount.amount, default: amount.default)
    end
  end
end
