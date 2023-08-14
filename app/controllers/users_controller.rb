class UsersController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new  # ユーザー登録ページ
  end

  def create  # ユーザー登録アクション
    @user = User.new(user_params)  # ユーザー登録フォームを送信したときの処理
    if @user.save
      auto_login(@user)
      redirect_to morning_activity_logs_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to users_url, success: t('.success')
  end

  private

  def user_params # ユーザー登録フォームを送信したときの処理
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
