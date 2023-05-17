class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :set_cache_headers
  add_flash_types :success, :info, :warning, :error

  private

  def not_authenticated
    flash[:error] = 'ログインしてください'
    redirect_to login_url
  end

  def set_cache_headers 
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
