require 'rails_helper'

RSpec.describe "Summaries", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/summaries/index"
      expect(response).to have_http_status(:success)
    end
  end

end
