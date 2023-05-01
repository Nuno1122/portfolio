class OauthController < ApplicationController
    class OauthsController < ApplicationController
        skip_before_action :require_login
        def oauth
          login_at(auth_params[:provider])
        end
      
        def callback
          provider = auth_params[:provider]
      
          if auth_params[:denied].present?
            redirect_to root_path, success: t('.denied.success')
            return
          end
      
          begin
            create_user_from(provider) unless (@user = login_from(provider))
            redirect_to morning_activity_logs_path, success: t('.success')
      
          rescue StandardError
            redirect_to root_path, error: t('.fail')
          end
        end
      
        private
      
        def auth_params
          params.permit(:provider, :denied, :oauth_token, :oauth_verifier)
        end
      
        def create_user_from(provider)
          @user = create_from(provider)
          reset_session
          auto_login(@user)
        end
      end
end
