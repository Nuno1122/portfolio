class UserSessionsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, notice: "ログインしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました"
  end
end