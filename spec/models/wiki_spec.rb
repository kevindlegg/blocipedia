require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:collaborators) }
  it { is_expected.to have_many(:users).through(:collaborators) }

  describe "attributes" do
    it "has title, body and private (false) attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, private: wiki.private)
    end
  end
end
