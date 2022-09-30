if Rails.env.production?
  CarrierWave.ocnfigure do |config|
    config.root = Rails.root.join('tmp')
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end
end
