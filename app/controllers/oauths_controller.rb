class OauthsController < ApplicationController
  # ログインが必須でないのでアクセスを許可
  skip_before_action :require_login

  # oauthメソッドでは、指定されたプロバイダからログインを試みます
  def oauth
    login_at(auth_params[:provider])
  end

  # callbackメソッドでは、プロバイダからのリダイレクトを処理します
  def callback
    # プロバイダ名を取得します
    provider = auth_params[:provider]

    # もしユーザーが認証を拒否した場合、メッセージを表示してホームページにリダイレクトします
    if auth_params[:denied].present?
      redirect_to root_path, success: t('.denied.success')
      return
    end

    begin
      # ユーザーが既に存在する場合はログインし、存在しない場合は新規作成します
      create_user_from(provider) unless (@user = login_from(provider))
      # 成功したら、メッセージを表示して打刻機能のページにリダイレクトします
      redirect_to morning_activity_logs_path, success: t('.success')
    # エラーが起きた場合は、ログにエラーメッセージを記録し、ホームページにリダイレクトします
    rescue StandardError => e
      Rails.logger.error e.message
      redirect_to root_path, error: t('.fail')
    end
  end

  # 以下はprivateメソッドです

  # auth_paramsメソッドでは、許可されたパラメータを取得します
  private

  def auth_params
    params.permit(:provider, :denied, :oauth_token, :oauth_verifier)
  end

  # create_user_fromメソッドでは、指定されたプロバイダからユーザーを新規作成します
  def create_user_from(provider)
    @user = create_from(provider)
    # セッションをリセットします
    reset_session
    # 自動的に新しく作成されたユーザーとしてログインします
    auto_login(@user)
  end
end
