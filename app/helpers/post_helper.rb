module PostHelper
  def new_post_count_badge
    current_dogrun_new_posts_count = Post.where(dogrun_place_id: current_user.dogrun_place_id).where(acknowledge: false).count
    unless current_dogrun_new_posts_count == 0
      tag.span class: "flex w-5 h-5 ml-3" do
        concat tag.span(class: "animate-ping inline-flex h-full w-full rounded-full aspect-square bg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(current_dogrun_new_posts_count, class: "text-sm font-medium relative inline-flex w-5 h-5 rounded-full bg-indigo-500 dark:bg-indigo-300 text-gray-200 dark:text-gray-700 justify-center aspect-square right-5")
      end
    end
  end

  def new_post_badge(post)
    if post.acknowledge == false
      tag.div class: "flex relative w-0 h-0" do
        concat tag.span(class: "content-center top-3 w-3 h-3 absolute animate-ping rounded-full aspect-square bbg-indigo-400 dark:bg-indigo-200 opacity-75")
        concat tag.span(class: "content-center top-3 rounded-full aspect-square h-3 w-3 relative bg-indigo-500 dark:bg-indeigo-300")
      end
    end
  end
end
