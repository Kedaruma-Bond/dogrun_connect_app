module PostHelper

  def post_viewing(post)
    case post.post_type
    when 'article'
      render partial: 'shared/article', locals: { post: post }
    when 'embed'
      case post.embed.embed_type
      when 'twitter'
        render partial: 'shared/twitter', locals: { post: post }
      when 'instagram'
        render partial: 'shared/instagram', locals: { post: post }
      when 'fb'
        render partial: 'shared/facebook', locals: { post: post }
      end
    end
  end

  def new_post_count_badge(admin_user)
    current_dogrun_new_articles_count = Post.joins(:article).where(dogrun_place_id: admin_user.dogrun_place_id, acknowledge: false).count
    current_dogrun_new_embeds_count = Post.joins(:embed).where(dogrun_place_id: admin_user.dogrun_place_id, acknowledge: false).count
    current_dogrun_new_posts_count = current_dogrun_new_articles_count + current_dogrun_new_embeds_count
    unless current_dogrun_new_posts_count == 0
      tag.span class: "flex w-5 h-5 ml-3" do
        concat tag.span(class: "animate-ping inline-flex h-full w-full rounded-full aspect-square bg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(current_dogrun_new_posts_count, class: "text-sm font-medium relative inline-flex w-5 h-5 rounded-full bg-indigo-500 dark:bg-indigo-300 text-gray-200 dark:text-gray-700 justify-center aspect-square right-5")
      end
    end
  end

  def new_post_badge(post)
    if post.acknowledge == false
      tag.div class: "flex relative w-0 h-0 ml-2" do
        concat tag.span(class: "content-center top-3 w-3 h-3 absolute animate-ping rounded-full aspect-square bbg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(class: "content-center top-3 rounded-full aspect-square h-3 w-3 relative bg-indigo-500 dark:bg-indeigo-300")
      end
    end
  end
end
