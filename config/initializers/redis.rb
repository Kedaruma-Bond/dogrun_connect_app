$redis = Redis.new(url: Rails.application.credentials['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
