class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.friendly.find(params[:id])
    @friendship = current_user.friendships.where(friend_id: @user).first
    @statuses = @user.statuses.order('created_at desc')
  end
end
