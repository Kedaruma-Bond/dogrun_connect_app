# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.dogrunconnect.com"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  Rails.application.credentials.aws[:s3_bucket_name],
  aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
  aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
  aws_region: 'ap-northeast-1'
)
SitemapGenerator::Sitemap.sitemaps_host = "https//s3-ap-northeast-1.amazonaws.com/#{Rails.application.credentials.aws[:s3_bucket_name]}"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'


SitemapGenerator::Sitemap.create do
  add '/togo_inu_shitsuke_hiroba/top', :priority => 0.8, :changefreq => 'daily'
  add '/reon/top', :priority => 0.8, :changefreq => 'daily'
end
