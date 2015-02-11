require 'rails_helper'

RSpec.describe StatusesController, :type => :controller do

  let(:user) { create(:user) }
  let(:hacker) { create(:user) } #just a simple user who thinks he's smart
  let(:admin) { create(:admin) }
  let(:valid_attributes) { { content: "My status", user_id: user.id } }
  let(:invalid_attributes) { { content: "M", user_id: user.id } }
  let(:valid_session) { {} }

  describe "GET index" do
    context "when not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns all statuses as @statuses" do
        status = Status.create! valid_attributes
        get :index
        expect(assigns(:statuses)).to eq([status])
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      it "assigns all statuses as @statuses" do
        status = Status.create! valid_attributes
        get :index
        expect(assigns(:statuses)).to eq([status])
      end
    end
  end

  describe "GET show" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        get :show, id: status.id
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        get :show, {:id => status.to_param}, valid_session
        expect(assigns(:status)).to eq(status)
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        get :show, {:id => status.to_param}, valid_session
        expect(assigns(:status)).to eq(status)
      end

    end
  end

  describe "GET new" do
    context "when not logged in" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns a new status as @status" do
        xhr :get, :new
        expect(assigns(:status)).to be_a_new(Status)
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      it "assigns a new status as @status" do
        xhr :get, :new
        expect(assigns(:status)).to be_a_new(Status)
      end

    end
  end

  describe "GET edit" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        get :edit, {:id => status.to_param}, valid_session
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        xhr :get, :edit, {:id => status.to_param}, valid_session
        expect(assigns(:status)).to eq(status)
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        xhr :get, :edit, {:id => status.to_param}, valid_session
        expect(assigns(:status)).to eq(status)
      end
    end

    context "when logged in as hacker" do
      before do
        sign_in(hacker)
      end

      it "redirects with remote" do
        status = Status.create! valid_attributes
        xhr :get, :edit, {:id => status.to_param}, valid_session
        expect(response).to redirect_to(statuses_path)
      end

      it "redirects without remote" do
        status = Status.create! valid_attributes
        get :edit, {:id => status.to_param}, valid_session
        expect(response).to redirect_to(statuses_path)
      end
    end
  end

  describe "POST create" do
    context "when not logged in" do
      it "redirects to the login page" do
        post :create, {:status => valid_attributes}, valid_session
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      describe "with valid params" do
        it "creates a new Status" do
          expect {
            xhr :post, :create, {:status => valid_attributes}, valid_session
          }.to change(Status, :count).by(1)
        end

        it "assigns a newly created status as @status" do
          xhr :post, :create, {:status => valid_attributes}, valid_session
          expect(assigns(:status)).to be_a(Status)
          expect(assigns(:status)).to be_persisted
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved status as @status" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(assigns(:status)).to be_a_new(Status)
        end

        it "re-renders the 'new' template" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      describe "with valid params" do
        it "creates a new Status" do
          expect {
            xhr :post, :create, {:status => valid_attributes}, valid_session
          }.to change(Status, :count).by(1)
        end

        it "assigns a newly created status as @status" do
          xhr :post, :create, {:status => valid_attributes}, valid_session
          expect(assigns(:status)).to be_a(Status)
          expect(assigns(:status)).to be_persisted
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved status as @status" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(assigns(:status)).to be_a_new(Status)
        end

        it "re-renders the 'new' template" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "PUT update" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        put :update, { :id => status.to_param, status: { content: "My new status" } }
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      describe "with valid params" do
        let(:new_attributes) { { content: "My new status" } }

        it "updates the requested status" do
          status = Status.create! valid_attributes
          expect {
            xhr :put, :update, {:id => status.to_param, :status => new_attributes}, valid_session
            status.reload
          }.to change{status.content}
        end

        it "assigns the requested status as @status" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => valid_attributes}, valid_session
          expect(assigns(:status)).to eq(status)
        end
      end

      describe "with invalid params" do
        it "assigns the status as @status" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
          expect(assigns(:status)).to eq(status)
        end

        it "re-renders the 'edit' template" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      describe "with valid params" do
        let(:new_attributes) { { content: "My new status" } }

        it "updates the requested status" do
          status = Status.create! valid_attributes
          expect {
            xhr :put, :update, {:id => status.to_param, :status => new_attributes}, valid_session
            status.reload
          }.to change{status.content}
        end

        it "assigns the requested status as @status" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => valid_attributes}, valid_session
          expect(assigns(:status)).to eq(status)
        end
      end

      describe "with invalid params" do
        it "assigns the status as @status" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
          expect(assigns(:status)).to eq(status)
        end

        it "re-renders the 'edit' template" do
          status = Status.create! valid_attributes
          xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    context "when logged in as hacker" do
      before do
        sign_in(hacker)
      end

      it "redirects with remote" do
        status = Status.create! valid_attributes
        xhr :put, :update, { :id => status.to_param, status: { content: "My new status" } }
        expect(response).to redirect_to(statuses_path)
      end

      it "redirects without remote" do
        status = Status.create! valid_attributes
        put :update, { :id => status.to_param, status: { content: "My new status" } }
        expect(response).to redirect_to(statuses_path)
      end
    end
  end

  describe "DELETE destroy" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        delete :destroy, id: status.id
        expect(response).to redirect_to(login_path)
      end

      it "does not destroy any status" do
        status = Status.create! valid_attributes
        expect(Status.count).to eq(1)
        delete :destroy, {:id => status.to_param}, valid_session
        expect(Status.count).to eq(1)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "destroys the requested status" do
        status = Status.create! valid_attributes
        expect {
          xhr :delete, :destroy, {:id => status.to_param}, valid_session
        }.to change(Status, :count).by(-1)
      end
    end

    context "when logged in as admin" do
      before do
        sign_in(admin)
      end

      it "destroys the requested status" do
        status = Status.create! valid_attributes
        expect {
          xhr :delete, :destroy, {:id => status.to_param}, valid_session
        }.to change(Status, :count).by(-1)
      end
    end

    context "when logged in as hacker" do
      before do
        sign_in(hacker)
      end

      it "redirects with remote" do
        status = Status.create! valid_attributes
        expect(Status.count).to eq(1)
        xhr :delete, :destroy, {:id => status.to_param}, valid_session
        expect(response).to redirect_to(statuses_path)
        expect(Status.count).to eq(1)
      end

      it "redirects without remote" do
        status = Status.create! valid_attributes
        expect(Status.count).to eq(1)
        delete :destroy, {:id => status.to_param}, valid_session
        expect(response).to redirect_to(statuses_path)
        expect(Status.count).to eq(1)
      end
    end
  end

  describe "PUT upvote" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        put :upvote, id: status.id
        expect(response).to redirect_to(login_path)
      end

      it "does not influence the upvotes" do
        status = Status.create! valid_attributes
        expect(status.cached_votes_up).to eq(0)
        put :upvote, id: status.id
        status.reload
        expect(status.cached_votes_up).to eq(0)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns a status as @status" do
        status = Status.create! valid_attributes
        xhr :put, :upvote, id: status.id
        expect(assigns(:status)).to eq(status)
      end

      it "increases the number of upvotes" do
        status = Status.create! valid_attributes
        expect{
          xhr :put, :upvote, id: status.id
          status.reload
        }.to change{ status.cached_votes_up }.from(0).to(1)
      end
    end
  end

  describe "PUT downvote" do
    context "when not logged in" do
      it "redirects to the login page" do
        status = Status.create! valid_attributes
        put :downvote, id: status.id
        expect(response).to redirect_to(login_path)
      end

      it "does not influence the downvotes" do
        status = Status.create! valid_attributes
        expect(status.cached_votes_down).to eq(0)
        put :downvote, id: status.id
        status.reload
        expect(status.cached_votes_down).to eq(0)
      end
    end

    context "when logged in" do
      before do
        sign_in(user)
      end

      it "assigns a status as @status" do
        status = Status.create! valid_attributes
        xhr :put, :downvote, id: status.id
        expect(assigns(:status)).to eq(status)
      end

      it "increases the number of upvotes" do
        status = Status.create! valid_attributes
        expect{
          xhr :put, :downvote, id: status.id
          status.reload
        }.to change{ status.cached_votes_down }.from(0).to(1)
      end
    end
  end
end
