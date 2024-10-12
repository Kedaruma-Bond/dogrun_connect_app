$redis = Redis.new(url: ENV['REDIS_TEMPORARY_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
