require 'active_support'

module PostConcern
  extend ActiveSupport::Concern

  def set_new_post
    @post = Post.new
  end

end
