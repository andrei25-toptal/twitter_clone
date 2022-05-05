module Api
  class UsersController < Api::ApplicationController
    before_action :authorize_request, except: :create

    # def me
    #   render json: @current_user
    # end

    def index
      @users = User.all
      render json: @users, include: ''
    end

    def show
      @user = User.find(params[:id])

      render json: @user
    rescue ActiveRecord::RecordNotFound
      render json: { error: "user not found" }, code: :not_found
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user
      else
        render json: { error: @user.errors }
      end
    end

    def update
      @user = User.find(params[:id])
      
      if @user.update(user_params)
        render json: @user
      else
        render json: { error: @user.errors }
      end
    rescue ActiveRecord::RecordNotFound
        render json: { error: "user not found" }, code: :not_found
    end

    def destroy
      @user = User.find(params[:id])

      @user.destroy
      render json: { message: "user destroyed"}

    rescue ActiveRecord::RecordNotFound
        render json: { error: "user not found" }, code: :not_found
    end
    
    
    private

    def user_params
      params.require(:user).permit(:username, :bio)
    end
  end
end