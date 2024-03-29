class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to morning_activity_logs_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def guest_login
    @guest_user = User.create!(
      name: 'ゲストユーザー',
      email: "#{SecureRandom.alphanumeric(10)}@example.com",
      password: 'password',
      password_confirmation: 'password'
    )
    auto_login(@guest_user)
    redirect_back_or_to morning_activity_logs_path, success: t('.success')
  end

  def destroy
    reset_session
    redirect_to root_path, success: t('.success')
  end
end
