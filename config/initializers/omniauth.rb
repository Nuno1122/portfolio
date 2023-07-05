Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter2,
           Rails.application.credentials.twitter[:client_id],
           Rails.application.credentials.twitter[:client_secret],
           callback_path: "/auth/twitter2/callback",
           scope: "tweet.read users.read"

  OmniAuth.config.on_failure =
    Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
end