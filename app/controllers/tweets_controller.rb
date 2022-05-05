class TweetsController < ApplicationController
  before_action :authenticate_user

  def index
    @tweets = Tweet.all
    # @tweets = current_user.tweets.all
    render json: @tweets
  end

  def new
    @user = User.new
  end

  def show
    @tweet = Tweet.find(params[:id])
    render json: @tweet
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render json: @user.errors
    end
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    if @user.destroy
      render json: User.all
    else
      render json: @user.errors
    end

  end

  private
    def user_params
      params.require(:user).permit(:name, :username, :bio, :email)
    end

    def authenticate_user
      unless logged_in?
        flash.alert = "Please log in."
        redirect_to login_url
      end
    end
end