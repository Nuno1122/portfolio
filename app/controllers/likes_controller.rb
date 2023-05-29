class LikesController < ApplicationController
  def create
    post = Post.includes(:likes).find(params[:post_id])
    current_user.like(post)
    render turbo_stream: turbo_stream.replace(
      post,
      partial: 'likes/like_button',
      locals: { post: post }
    )
  end

  def destroy
    post = Post.includes(:likes).find(params[:post_id])
    current_user.unlike(post)
    render turbo_stream: turbo_stream.replace(
      post,
      partial: 'likes/like_button',
      locals: { post: post }
    )
  end
end
