class CommentsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to @post, flash: { success: t('.success') }
    else
      flash.now[:error] = t('.fail')
      render 'posts/show', status: :unprocessable_entity
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.post, success: t('.success')
  end
  
private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end