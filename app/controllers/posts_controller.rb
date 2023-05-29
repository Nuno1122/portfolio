class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  def index
    @posts = Post.includes(user: %i[start_time_plan morning_activity_logs]).order(created_at: :desc).page(params[:page])
  end
  

  def new
    @post = Post.new
  end  

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
    session[:return_to] = request.referer
    @post = Post.find(params[:id])
    render turbo_stream: turbo_stream.replace(
      @post,
      partial: 'edit_modal',  # _edit を _edit_modal に変更
      locals: { post: @post }
    )
  end
  
  def update
    @post = Post.find(params[:id])
  
    if @post.update(post_params)
      redirect_to session.delete(:return_to), success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render '_edit_modal', status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy!
    redirect_to posts_path, success: t('.success')
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def set_post
    @post = Post.includes(comments: :user).find(params[:id])
  end
    
end
