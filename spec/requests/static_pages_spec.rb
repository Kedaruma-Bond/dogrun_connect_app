require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/static_pages/top"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy_policy" do
    it "returns http success" do
      get "/static_pages/privacy_policy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms_of_service" do
    it "returns http success" do
      get "/static_pages/terms_of_service"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/static_pages/contact"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /compliance_confirmations" do
    it "returns http success" do
      get "/static_pages/compliance_confirmations"
      expect(response).to have_http_status(:success)
    end
  end

end
