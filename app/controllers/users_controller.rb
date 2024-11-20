class UsersController < ApplicationController

    def new
      @user = User.new
    end
  
    def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: 'Account created successfully! Please log in.'
    else
      flash.now[:alert] = 'Failed to create account. Please check your input.'
      render :new, status: :unprocessable_entity
    end
  end

    def profile
        @user = current_user # ดึงข้อมูลผู้ใช้ที่ล็อกอินเข้ามา
    end

    def follow
        @user = User.find(params[:id])
        if current_user.follow(@user)
          redirect_to dashboard_path, notice: "You are now following #{@user.name}."
        else
          redirect_to dashboard_path, alert: "Unable to follow user."
        end
      end
    
      def unfollow
        @user = User.find(params[:id])
        if current_user.unfollow(@user)
          redirect_to dashboard_path, notice: "You have unfollowed #{@user.name}."
        else
          redirect_to dashboard_path, alert: "Unable to unfollow user."
        end
      end

      def update
        if @user.update(user_params)
          redirect_to profile_path, notice: 'Profile updated successfully.'
        else
          render :edit
        end
      end

    private
  
    def user_params
        params.require(:user).permit(:email,:password, :password_confirmation)
      end
  end
  