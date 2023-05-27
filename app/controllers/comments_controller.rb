class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to @post, flash: { success: t('.success') }
    else
      flash.now[:error] = t('.fail')
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def edit
    session[:return_to] = request.referer
    render turbo_stream: turbo_stream.replace(
      @post,
      partial: 'comment_edit_modal',
      locals: { post: @post }
    )
  end

  def update
    if @comment.update(comment_params)
      redirect_to session.delete(:return_to), success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render '_comment_edit_modal', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.post, success: t('.success')
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def set_post
    @post = Post.find(params[:post_id])
  end
  
  def set_comment
    @comment = @post.comments.find(params[:id])
  end
end