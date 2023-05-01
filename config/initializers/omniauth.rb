Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV.fetch('TWITTER_API_KEY', nil), ENV.fetch('TWITTER_API_SECRET', nil)
end
