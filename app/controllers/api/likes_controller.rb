module Api
  class LikesController < ApplicationController
    def index
      @likes = Like.where(tweet_id: params[:tweet_id])
      render json: @likes, include: ''
    end

    def show
      @user = User.find_by(username: params[:id])

      if @user
        @like = Like.find_by(tweet_id: params[:tweet_id], user_id: @user.id)

        if @like
          render json: @like
        else
          render json: { error: "like not found" }, code: :not_found
        end

      else
        render json: { error: "user not found" }
      end
    end

    def create
      @like = Like.new(like_params)

      if @like.save
        render json: @like
      else
        render json: { error: @like.errors }
      end
    end

    def destroy
      @like = Like.find(params[:id])

      @like.destroy
      render json: { message: "like destroyed"}

    rescue ActiveRecord::RecordNotFound
      render json: { error: "like not found" }, code: :not_found
    end
    
    
    private

    def like_params
      params.require(:like).permit(:user_id).merge({ "tweet_id" => params[:tweet_id] })
    end
  end
end