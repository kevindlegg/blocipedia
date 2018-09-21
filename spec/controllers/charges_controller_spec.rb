require 'rails_helper'
require 'stripe'

RSpec.describe ChargesController, type: :controller do
  let(:my_stripe_token) { Stripe::Token.create( card: { number: "4242424242424242", exp_month: 01, exp_year: 2020, cvc: "242" }) }
  let(:my_user) { create(:user, stripe_customer_token: my_stripe_token.id) }

  before { sign_in my_user }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    it "returns http success" do
      delete :destroy, params: { id: my_user.stripe_customer_token }
      expect(response).to have_http_status(:success)
    end
  end
end
