class GraphqlController < ApplicationController
  skip_forgery_protection

  def index
    # render json: TweetsSchema.execute(params[:query])
    render json: TweetsSchema.execute(params[:query], variables: params[:variables])
  end
end