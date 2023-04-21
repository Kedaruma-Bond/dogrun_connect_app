module UserDetailHelper
  def set_postcodejp_apikey
    Rails.application.credentials.postcodejp_api.apikey
  end
end
