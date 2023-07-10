require 'rails_helper'

RSpec.describe "Rankings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rankings" # ここを編集
      expect(response).to have_http_status(:success)
    end
  end
end
