require 'rails_helper'

RSpec.describe FriendshipsController, :type => :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe "GET index" do
    describe "when not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        sign_in(user)
      end

      it "gets the index page without errors" do
        get :index
        expect(response.status).to eq(200)
      end

      it "assigns a new @friendships variable" do
        friendship1 = create(:pending_friendship, user: user, friend: user2)
        friendship2 = create(:accepted_friendship, user: user, friend: user3)
        get :index
        expect(assigns(:friendships)).to eq([friendship1, friendship2])
      end
    end
  end

  describe "GET new" do
    describe "when not logged in" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      render_views

      before do
        sign_in(user)
      end

      it "assigns a new friendship as @friendship" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship)).to be_a_new(Friendship)
      end

      it "returns success" do
        get :new, { friend_id: user2 }
        expect(response.status).to eq(200)
      end

      it "sets up flash error when friend id is missing" do
        get :new
        expect(flash[:error]).to eq("Friend required.")
      end

      it "redirects when friend id is missing" do
        get :new
        expect(response).to redirect_to(statuses_path)
      end

      it "assigns the proper friend" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship).friend).to eq(user2)
      end

      it "assigns the currently logged in user" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship).user).to eq(user)
      end

      it "asks if the user is sure about the frienship" do
        get :new, { friend_id: user2 }
        expect(response.body).to include("Are you sure you want to request this friend?")
      end

      it "returns a 404 when friend is not found" do
        get :new, { friend_id: "invalid" }
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST create" do
    describe "when not logged in" do
      it "redirects to the login page" do
        post :create
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        sign_in(user)
      end

      describe "when friend id is missing" do
        it "displays flash error" do
          post :create
          expect(flash[:error]).to_not be_empty
        end

        it "redirects to statuses page" do
          post :create
          expect(response).to redirect_to(statuses_path)
        end
      end
    end
  end

  describe "PUT accept" do
    describe "when not logged in" do
      it "redirects to the login page" do
        put :accept, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        Friendship.request(user, user2)
        sign_in(user2)
      end

      it "sets both friendships' state to accepted" do
        friendship = Friendship.where(user_id: user.id).first
        friendship2 = Friendship.where(friend_id: user.id).first
        expect(friendship.state).to eq("pending")
        expect(friendship2.state).to eq("requested")
        put :accept, id: friendship2.id
        friendship.reload
        friendship2.reload
        expect(friendship.state).to eq("accepted")
        expect(friendship2.state).to eq("accepted")
      end

      it "assigns a new @friendship variable" do
        friendship2 = Friendship.where(user_id: user2.id).first
        put :accept, id: friendship2.id
        expect(assigns(:friendship)).to eq(friendship2)
      end

      it "sets a success flash message" do
        friendship2 = Friendship.where(user_id: user2.id).first
        put :accept, id: friendship2.id
        expect(flash[:success]).to eq("You are now friends with #{friendship2.friend.name}")
      end
    end
  end

  describe "PUT block" do
    describe "when not logged in" do
      it "redirects to the login page" do
        put :block, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        Friendship.request(user, user2)
        sign_in(user)
      end

      it "assigns a friendship variable" do
        friendship = Friendship.first
        put :block, id: friendship.id
        expect(assigns(:friendship)).to eq(friendship)
      end

      it "changes the state of a frienship to blocked" do
        friendship = Friendship.first
        put :block, id: friendship.id
        friendship.reload
        expect(friendship.state).to eq("blocked")
      end

      it "blocks the other friendship" do
        friendship = Friendship.first
        friendship2 = Friendship.last
        put :block, id: friendship.id
        friendship2.reload
        expect(friendship2.state).to eq("blocked")
      end
    end
  end

  describe "GET edit" do
    describe "when not logged in" do
      it "redirects to the login page" do
        get :edit, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do

      before do
        Friendship.request(user, user2)
        sign_in(user)
      end

      it "response is a success" do
        friendship2 = Friendship.first
        get :edit, id: friendship2
        expect(response.status).to eq(200)
      end

      it "assigns a new friendship variable" do
        friendship = Friendship.where(user_id: user.id).first
        get :edit, id: friendship.id
        expect(assigns(:friendship)).to eq(friendship)
      end

      it "assigns a new @friend variable" do
        friendship = Friendship.where(user_id: user.id).first
        get :edit, id: friendship.id
        expect(assigns(:friend)).to eq(user2)
      end
    end
  end

  describe "DELETE destroy" do
    describe "when not logged in" do
      it "redirects to the login page" do
        delete :destroy, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        Friendship.request(user, user2)
        expect(Friendship.count).to eq(2)
        sign_in(user)
      end

      it "assigns a new friendship variable" do
        friendship = Friendship.where(user_id: user.id).first
        delete :destroy, id: friendship.id
        expect(assigns(:friendship)).to eq(friendship)
      end

      it "deletes a mutual friendship" do
        friendship = Friendship.where(user_id: user.id).first
        delete :destroy, id: friendship.id
        expect(Friendship.count).to eq(0)
      end
    end
  end
end
