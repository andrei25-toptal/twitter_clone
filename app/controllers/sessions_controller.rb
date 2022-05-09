class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect = session.delete(:redirected_from)
      redirect_to redirect || root_path
    else
      render 'new'
    end
  end

  def destroy
    log_out
    flash.notice = "You have successfully logged out"
    redirect_to login_url
  end
end