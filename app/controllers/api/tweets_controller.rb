module Api
  class TweetsController < Api::ApplicationController

    # TOKEN = "secret"
    # before_action :authenticate, except: [:index]
    before_action :authorize_request

    
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

    # def authenticate
    #   authenticate_or_request_with_http_token do |token, options|
    #     ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    #   end
    # end

  end
end


# curl --request GET \
#   --url http://127.0.0.1:3000/tweets/1 \
#   --header 'Authorization: Bearer secret' \
#   --header 'Content-Type: application/json'