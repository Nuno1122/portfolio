class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]# このコントローラのshow, edit, update, destroyアクションでは、set_postメソッドを実行する
  skip_before_action :require_login, only: [:index, :show]# このコントローラのindexアクションでは、ログイン要求をスキップし、ログインしていないユーザーでもランキングページを閲覧できるようにする
  def index
    @posts = Post.includes(user: %i[start_time_plan morning_activity_logs]).order(created_at: :desc).page(params[:page])
    @achieved_count = params[:achieved_count].to_i
    @previous_achieved_count = params[:previous_achieved_count].to_i
  end
  

  def new
    @post = Post.new
    @morning_activity_not_allowed = MorningActivityLog.is_morning_activity_not_allowed?(current_user)
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
