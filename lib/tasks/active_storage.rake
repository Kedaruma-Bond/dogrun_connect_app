namespace :active_storage do
  desc "Migrate image attach to use Active Storage"
  task migrate_image_attach: :environment do
    Article.find_each do |article|
      filename = File.basename(URI.parse(article.image_attach.url))
      article.image_attach_new.attach(io: open(article.image_attach.url), filename: d.image_attach)
    end
  end
end
