require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'POST /create' do
    it 'returns http redirect' do
      post '/posts/1/likes'
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http redirect' do
      delete '/posts/1/likes'
      expect(response).to have_http_status(:redirect)
    end
  end
end
