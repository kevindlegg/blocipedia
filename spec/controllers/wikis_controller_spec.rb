require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:standard_user) { create(:user) }
  let(:premium_user) { create(:user, role: :premium) }
  let(:admin_user) { create(:user, role: :admin) }

  let(:my_wiki) { create(:wiki, user: standard_user) }
  let(:premium_wiki) { create(:wiki, user: premium_user) }
  let(:private_wiki) { create(:wiki, private: true, user: premium_user) }

  context "guest user" do
    describe "GET #index" do
      before { get :index }
      it "returns http success" do
        expect(response).to be_successful
      end

      it "assigns public wikis to @wikis" do
        expect(assigns(:wikis)).to eq([my_wiki])
      end

      it "does not assign private wikis to @wikis" do
        expect(assigns(:wikis)).to_not eq([private_wiki])
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
      it "does not delete the wiki" do
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

    context "public wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "assigns Wiki.all to @wikis" do
          expect(assigns(:wikis)).to eq([my_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: my_wiki.id } }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #show view" do
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          expect(assigns(:wiki)).to eq(my_wiki)
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
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
        context "owns wiki" do
          before do
            get :edit, params: { id: my_wiki.id }
          end

          it "returns http success" do
            expect(response).to be_successful
          end

          it "renders the #edit view" do
            expect(response).to render_template :edit
          end

          it "assigns wiki to be updated to @wiki" do
            wiki_instance = assigns(:wiki)

            expect(wiki_instance.id).to eq my_wiki.id
            expect(wiki_instance.title).to eq my_wiki.title
            expect(wiki_instance.body).to eq my_wiki.body
          end
        end

        context "wiki owned by anther user" do
          before do
            premium_wiki { create(:wiki, user: premium_user) }
            get :edit, params: { id: premium_wiki.id }
          end

          it "returns http success" do
            expect(response).to_not be_successful
          end

          it "redirects to wikis_path" do
            expect(response).to redirect_to(wikis_path)
          end

          it "cannot assign wiki to be updated to @wiki" do
            wiki_instance = assigns(:wiki)

            expect(wiki_instance).to be_nil
          end
        end
      end

      describe "PUT update" do
        context "owns wiki" do
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

        context "wiki owned by anther user" do
          before do
            premium_wiki { create(:wiki, user: premium_user) }
          end
          it "updates wiki with expected attributes" do
            new_title = RandomData.random_sentence
            new_body = RandomData.random_paragraph

            put :update, params: {
              id: premium_wiki.id,
              wiki: { title: new_title, body: new_body }
            }
            updated_wiki = assigns(:wiki)

            expect(updated_wiki).to be_nil
          end

          it "redirects to the updated wiki" do
            new_title = RandomData.random_sentence
            new_body = RandomData.random_paragraph

            put :update, params: {
              id: premium_wiki.id,
              wiki: { title: new_title, body: new_body }
            }
            expect(response).to redirect_to(wikis_path)
          end
        end
      end

      describe "DELETE destroy" do
        context "owns wiki" do
          before { delete :destroy, params: { id: my_wiki.id } }
          it "deletes the wiki" do
            count = Wiki.where(id: my_wiki.id).size
            expect(count).to eq 0
          end

          it "redirects to wikis index" do
            expect(response).to redirect_to wikis_path
          end
        end

        context "wiki owned by another user" do
          before do
            premium_wiki { create(:wiki, user: premium_user) }
          end
          before { delete :destroy, params: { id: premium_wiki.id } }
          it "deletes the wiki" do
            count = Wiki.where(id: my_wiki.id).size
            expect(count).to eq 1
          end

          it "redirects to wikis index" do
            expect(response).to redirect_to wikis_path
          end
        end
      end
    end

    context "private wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "does not assign private wikis to @wikis" do
          expect(assigns(:wikis)).to_not eq([private_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: private_wiki.id } }
        it "redirects to wikis_path" do
          expect(response).to redirect_to(wikis_path)
        end

        it "@wiki is nil" do
          expect(assigns(:wiki)).to be_nil
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
          expect(assigns(:wiki)).to_not be_nil
        end
      end

      describe "wiki create" do
        it "does not increase the number of wikis" do
          expect{
            post :create, params: {
              wiki: {
                title: RandomData.random_sentence,
                body: RandomData.random_paragraph,
                private: true
              }
            }
          }.to_not change(Wiki, :count)
        end

        it "does not assign Wiki.last to @wiki" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(assigns(:wiki)).to_not eq Wiki.last
        end

        it "redirects to the wikis" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "GET edit" do
        before { get :edit, params: { id: private_wiki.id } }
        it "returns http success" do
          expect(response).to_not be_successful
        end

        it "redirects to wikis_path" do
          expect(response).to redirect_to(wikis_path)
        end

        it "instance of wiki is nil" do
          wiki_instance = assigns(:wiki)

          expect(wiki_instance).to be_nil
        end
      end

      describe "PUT update" do
        it "cannot update the wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: private_wiki.id,
            wiki: {
              title: new_title,
              body:  new_body
            }
          }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki).to be_nil
        end

        it "redirects to the wikis_path" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: private_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "DELETE destroy" do
        before { delete :destroy, params: { id: private_wiki.id } }
        it "cannot delete the wiki" do
          count = Wiki.where(id: private_wiki.id).size
          expect(count).to eq 1
        end

        it "redirects to wikis index" do
          expect(response).to redirect_to wikis_path
        end
      end
    end
  end

  context "premium user" do
    before do
      sign_in premium_user
    end

    context "public wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "assigns Wiki.all to @wikis" do
          expect(assigns(:wikis)).to eq([my_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: my_wiki.id } }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #show view" do
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          expect(assigns(:wiki)).to eq(my_wiki)
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
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
        before do
          get :edit, params: { id: premium_wiki.id, }
        end

        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #edit view" do
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq premium_wiki.id
          expect(wiki_instance.title).to eq premium_wiki.title
          expect(wiki_instance.body).to eq premium_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq premium_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "DELETE destroy" do
        before { delete :destroy, params: { id: premium_wiki.id } }
        it "deletes the wiki" do
          count = Wiki.where(id: premium_wiki.id).size
          expect(count).to eq 0
        end

        it "redirects to wikis index" do
          expect(response).to redirect_to wikis_path
        end
      end
    end

    context "private wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "does not assign private wikis to @wikis" do
          expect(assigns(:wikis)).to eq([private_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: private_wiki.id } }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #show view" do
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          expect(assigns(:wiki)).to eq(private_wiki)
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
          expect(assigns(:wiki)).to_not be_nil
        end
      end

      describe "wiki create" do
        it "increases the number of wikis by 1" do
          expect{
            post :create, params: {
              wiki: {
                title: RandomData.random_sentence,
                body: RandomData.random_paragraph,
                private: true
              }
            }
          }.to change(Wiki, :count).by(1)
        end

        it "assigns Wiki.last to @wiki" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the wikis" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "GET edit" do
        before { get :edit, params: { id: private_wiki.id } }

        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #edit view" do
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq private_wiki.id
          expect(wiki_instance.title).to eq private_wiki.title
          expect(wiki_instance.body).to eq private_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes including private" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: {
              title: new_title,
              body: new_body,
              private: true
            }
          }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq premium_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
          expect(updated_wiki.private).to eq true
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "DELETE destroy" do
        let(:private_wiki) { create(:wiki, user: premium_user) }
        before { delete :destroy, params: { id: private_wiki.id } }

        it "deletes the wiki" do
          count = Wiki.where(id: private_wiki.id).size
          expect(count).to eq 0
        end

        it "redirects to wikis index" do
          expect(response).to redirect_to wikis_path
        end
      end
    end
  end

  context "admin user" do
    before do
      sign_in admin_user
    end

    context "public wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "assigns Wiki.all to @wikis" do
          expect(assigns(:wikis)).to eq([my_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: my_wiki.id } }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #show view" do
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          expect(assigns(:wiki)).to eq(my_wiki)
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
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
        before do
          get :edit, params: { id: premium_wiki.id }
        end

        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #edit view" do
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq premium_wiki.id
          expect(wiki_instance.title).to eq premium_wiki.title
          expect(wiki_instance.body).to eq premium_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq premium_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "DELETE destroy" do
        before { delete :destroy, params: { id: premium_wiki.id } }
        it "deletes the wiki" do
          count = Wiki.where(id: premium_wiki.id).size
          expect(count).to eq 0
        end

        it "redirects to wikis index" do
          expect(response).to redirect_to wikis_path
        end
      end
    end

    context "private wikis" do
      describe "GET #index" do
        before { get :index }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "does not assign private wikis to @wikis" do
          expect(assigns(:wikis)).to eq([private_wiki])
        end
      end

      describe "GET #show" do
        before { get :show, params: { id: private_wiki.id } }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #show view" do
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          expect(assigns(:wiki)).to eq(private_wiki)
        end
      end

      describe "GET #new" do
        before { get :new }
        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #new view" do
          expect(response).to render_template :new
        end

        it "instantiates @wiki" do
          expect(assigns(:wiki)).to_not be_nil
        end
      end

      describe "wiki create" do
        it "increases the number of wikis by 1" do
          expect{
            post :create, params: {
              wiki: {
                title: RandomData.random_sentence,
                body: RandomData.random_paragraph,
                private: true
              }
            }
          }.to change(Wiki, :count).by(1)
        end

        it "assigns Wiki.last to @wiki" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the wikis" do
          post :create, params: {
            wiki: {
              title: RandomData.random_sentence,
              body: RandomData.random_paragraph,
              private: true
            }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "GET edit" do
        before { get :edit, params: { id: private_wiki.id } }

        it "returns http success" do
          expect(response).to be_successful
        end

        it "renders the #edit view" do
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq private_wiki.id
          expect(wiki_instance.title).to eq private_wiki.title
          expect(wiki_instance.body).to eq private_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes including private" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: {
              title: new_title,
              body: new_body,
              private: true
            }
          }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq premium_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
          expect(updated_wiki.private).to eq true
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: {
            id: premium_wiki.id,
            wiki: { title: new_title, body: new_body }
          }
          expect(response).to redirect_to(wikis_path)
        end
      end

      describe "DELETE destroy" do
        let(:private_wiki) { create(:wiki, user: premium_user) }
        before { delete :destroy, params: { id: private_wiki.id } }

        it "deletes the wiki" do
          count = Wiki.where(id: private_wiki.id).size
          expect(count).to eq 0
        end

        it "redirects to wikis index" do
          expect(response).to redirect_to wikis_path
        end
      end
    end
  end
end
