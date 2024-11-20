class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
    # Render login form
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      # Log in the user and redirect to dashboard
      log_in user  # This assumes you have a log_in helper method defined
      redirect_to dashboard_path, notice: "Logged in successfully."
    else
      # Render the login form with an error message if authentication fails
      flash.now[:alert] = "Invalid email or password."
      render 'new'
    end
  end

  def destroy
    # Log user out and clear session
    logger.info "User logged out (Session cleared)"
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully.'
  end

  private

  def redirect_if_authenticated
    if current_user
      redirect_to dashboard_path, alert: 'You are already logged in.'
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end

  # Assuming these helper methods are defined somewhere in your application:
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
