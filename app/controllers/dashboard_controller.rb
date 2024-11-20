class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @posts = Post.all.order(created_at: :desc)
    @suggested_users = User.where.not(id: current_user.id).limit(5) # ตัวอย่าง: แนะนำผู้ใช้ 5 คนที่ไม่ใช่ผู้ใช้ปัจจุบัน
    @posts = Post.includes(:user).order(created_at: :desc)
    logger.debug "Current user: #{current_user.inspect}"
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to login_path, alert: 'You must be logged in to access the dashboard.'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
