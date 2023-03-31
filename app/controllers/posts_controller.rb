class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
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

  private

  def post_params
    params.require(:post).permit(:content)
  end
  
end