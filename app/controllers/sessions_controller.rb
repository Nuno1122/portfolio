class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:create]
    def create
      user = User.find_or_create_from_auth(request.env["omniauth.auth"])
      session[:user_id] = user.id  # `uid`ではなく`id`を使用する
      redirect_back_or_to morning_activity_logs_path, success: t('.success')
    end
    
  
    def destroy
      reset_session
      redirect_to root_url, status: :see_other
    end
  
    def failure
      redirect_to root_url
    end
  end