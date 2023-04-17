class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login
  add_flash_types :success, :info, :warning, :error

  private

  def not_authenticated
    flash[:error] = 'ログインしてください'
    redirect_to login_url
  end
end