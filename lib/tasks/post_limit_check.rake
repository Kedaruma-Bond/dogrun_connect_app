namespace :post_limit_check do
  desc "掲示板の記事の掲示期限を確認して期限が切れたら掲示を止める"
  task check_limit: :environment do
    publishing_post = Post.where(publish_status: 'is_publishing')
    publishing_post.each do |post|
      if post.publish_limit < Time.zone.now
        post.update!(publish_status: 'non_publish')
      end
    end
  end
end
