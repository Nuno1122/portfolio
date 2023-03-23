class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :error
end
