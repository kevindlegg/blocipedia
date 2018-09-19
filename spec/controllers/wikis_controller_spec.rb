require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:standard_user) { create(:user) }
  let(:premium_user) { create(:user, role: :premium) }
  let(:admin_user) { create(:user, role: :admin) }

  let(:my_wiki) { create(:wiki, user: standard_user) }

  context "guest user" do

    describe "GET #index" do

      it "returns http success" do
        get :index
        expect(response).to be_successful
      end

      it "assigns Wiki.all to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    describe "GET #show" do
      it "redirects to wikis_path" do
        get :show, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end

      it "@wiki is nil" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to be_nil
      end
    end

    describe "GET #new" do
      it "redirects to wikis_path" do
        get :new
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "wiki create" do
      it "redirects to the wikis" do
        post :create, params: {
          wiki: { title: RandomData.random_sentence,
                  body: RandomData.random_paragraph }
        }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "PUT update" do
      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { 
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 1
      end

      it "redirects to wikis index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
    end
  end

  context "standard user" do
    before do
      sign_in standard_user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to be_successful
      end

      it "assigns Wiki.all to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to be_successful
      end

      it "renders the #show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to be_successful
      end

      it "renders the #new view" do
        get :new, params: { id: my_wiki.id }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { id: my_wiki.id }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "wiki create" do
      it "increases the number of wikis by 1" do
        expect{
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph
            }
          }
        }.to change(Wiki, :count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the wikis" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to be_successful
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: my_wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: {
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: {
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "premium user" do
    before do
      sign_in premium_user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to be_successful
      end

      it "assigns Wiki.all to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to be_successful
      end

      it "renders the #show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to be_successful
      end

      it "renders the #new view" do
        get :new, params: { id: my_wiki.id }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { id: my_wiki.id }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "wiki create" do
      it "increases the number of wikis by 1" do
        expect{
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph
            }
          }
        }.to change(Wiki, :count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the wikis" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to_not be_successful
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "PUT update" do
      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { 
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 1
      end

      it "redirects to wikis index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to(wikis_path)
      end
    end
  end

  context "admin user" do
    before do
      sign_in admin_user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to be_successful
      end

      it "assigns Wiki.all to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to be_successful
      end

      it "renders the #show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to be_successful
      end

      it "renders the #new view" do
        get :new, params: { id: my_wiki.id }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { id: my_wiki.id }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "wiki create" do
      it "increases the number of wikis by 1" do
        expect{
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph
            }
          }
        }.to change(Wiki, :count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the wikis" do
        post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to be_successful
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: my_wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: {
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: {
          id: my_wiki.id,
          wiki: { title: new_title, body: new_body }
        }
        expect(response).to redirect_to(wikis_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end
    end
  end

end
