class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[show index]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
  end
  def confirm_delete
    @post = Post.find(params[:id])
  end
  # GET /posts/1 or /posts/1.json
  def show
incremViews = @post.views == nil ? 1 : @post.views + 1
 @post.update(views:incremViews)   
 @comments = @post.comments == nil ? "no comements yet!" : @post.comments.order(created_at: :desc) 

end
  # GET /posts/new
  def new
     @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        @post.views.nil?
        @post.views = 0
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    def destroy
      @post = Post.find(params[:id])
      if @post.destroy
        flash[:notice] = 'Post was successfully deleted.'
      else
        flash[:error] = 'There was an error deleting the post.'
      end
      redirect_to posts_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
  
def mark_notifications_as_read
  if current_user
    notifications_to_mark_as_read = @post.notifications_as_post.where(recipient: current_user)
    notifications_to_mark_as_read.update_all(read_at: "now")


  end
end
    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :views)
    end
end
