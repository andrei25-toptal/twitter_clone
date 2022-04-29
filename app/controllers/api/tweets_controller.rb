module Api
  class TweetsController < ApplicationController
    def index
      @tweets = Tweet.all
      
      # User   -> Tweet
      # Tweet !-> User
      render json: @tweets, include: ''
    end

    def show
      @tweet = Tweet.find params[:id]

      render json: @tweet
    rescue ActiveRecord::RecordNotFound
      render json: { error: "tweet not found" }, status: :not_found
    end

    def create
      @tweet = Tweet.new tweet_params

      if @tweet.save
        render json: @tweet
      else
        render json: { error: @tweet.errors }
      end
    end

    def update
      @tweet = Tweet.find(params[:id])
      
      if @tweet.update tweet_params
        render json: @tweet
      else
        render json: { error: @tweet.errors }
      end
    rescue ActiveRecord::RecordNotFound
        render json: { error: "tweet not found" }, code: :not_found
    end

    def destroy
      @tweet = Tweet.find params[:id]

      @tweet.destroy
      render json: { message: "tweet destroyed"}

    rescue ActiveRecord::RecordNotFound
      render json: { error: "tweet not found" }, code: :not_found
    end



    # rescue_from(ActiveRecord::RecordNotFound) do
    #   render json: { error: "tweet not found" }, code: :not_found
    # end
    
    private

    # def handle_record_not_found
    # end

    def tweet_params
      params.require(:tweet).permit :user_id, :content
    end
  end
end