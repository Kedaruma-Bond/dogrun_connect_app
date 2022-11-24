module DogrunPlaceDecorator
  def facebook_account
    facebook_account = "https://www.facebook.com/" + facebook_id
    facebook_account
  end

  def instagram_account
    instagram_account = "https://www.instagram.com/" + instagram_id
    instagram_account
  end

  def twitter_account
    twitter_account = "https://twitter.com/" + twitter_id
    twitter_account
  end
end
