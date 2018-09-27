require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }
  let(:collaborator) { create(:collaborator, user: user, wiki: wiki) }

  it { is_expected.to belong_to(:wiki) }
  it { is_expected.to belong_to(:user) }
  
  describe "attributes" do
    it "it has wiki and user reference attributes" do
      expect(collaborator).to have_attributes(user: user, wiki: wiki)
    end
  end
end
