class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :all_statuses, only: [:index, :create, :update, :destroy]
  before_action :set_status, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :owner?, only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    respond_with(@statuses)
  end

  def show
    respond_with(@status)
  end

  def new
    @status = current_user.statuses.new
    respond_with(@status)
  end

  def edit
  end

  def create
    @status = current_user.statuses.new(status_params)
    unless @status.save
      render action: 'new'
    end
  end

  def update
    unless @status.update(status_params)
      render action: 'edit'
    end
  end

  def destroy
    unless @status.destroy
      redirect_to statuses_path, error: 'Status could not be deleted.'
    end
  end

  def upvote
    if current_user.voted_up_on? @status
      @status.unliked_by current_user
    else
      @status.upvote_by current_user
    end
  end

  def downvote
    if current_user.voted_down_on? @status
      @status.undisliked_by current_user
    else
      @status.downvote_by current_user
    end
  end

  private

  def all_statuses
    @friends = current_user.friends.pluck(:id)
    @friends << current_user.id
    @statuses = Status.all_statuses(@friends).page(params[:page]).order('created_at DESC')
  end

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:content)
  end

  def owner?
    unless @status.user == current_user || current_user.admin == true
      redirect_to statuses_path, error: "You are not allowed to do that"
    end
  end
end
