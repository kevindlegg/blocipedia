require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_wiki) { create(:wiki) }
  let(:my_collaborator) { create(:collaborator, user_id: my_user.id, wiki_id: my_wiki.id) }

  context "guest" do
    describe "POST create" do
      it "redirects the user to my_wiki view" do
        post :create, params: { wiki_id: my_wiki.id, user_id: my_user.id }
        expect(response).to redirect_to [my_wiki]
      end
    end

    describe "DELETE destroy" do
      it "redirects the user to my_wiki view" do
        delete :destroy, params: { id: my_collaborator.id, wiki_id: my_wiki.id }
        expect(response).to redirect_to [my_wiki]
      end
    end
  end

end
