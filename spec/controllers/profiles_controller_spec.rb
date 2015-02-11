require 'rails_helper'

RSpec.describe ProfilesController, :type => :controller do

  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "GET show" do
    it "returns http success" do
      get :show, { :id => user.slug }
      expect(response).to have_http_status(:success)
    end
  end

end
