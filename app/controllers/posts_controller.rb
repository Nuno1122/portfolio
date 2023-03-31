class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
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


  def show; end

  def destroy
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました。'
  end


  private

  def post_params
    params.require(:post).permit(:content)
  end

def set_post
    @post = Post.find(params[:id])
  end
  
end