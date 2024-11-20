class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:destroy, :edit, :update, :show]

  
    def index

    end
      
  
    def new
      @post = Post.new
    end
  
    def create
        @post = current_user.posts.build(post_params)
        if @post.save
          redirect_to dashboard_path, notice: 'Post created successfully!'
        else
          flash.now[:alert] = 'Failed to create post. Please check your input.'
          render :new, status: :unprocessable_entity
        end
      end
  
    def edit
        redirect_to posts_path, alert: "Not authorized" unless @post.user == current_user
    end
      
    def update
        if @post.user == current_user && @post.update(post_params)
          redirect_to @post, notice: "Post was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
    end
  
    def destroy
      if @post.user == current_user
        @post.destroy
        redirect_to posts_path, notice: "Post was successfully deleted."
      else
        redirect_to posts_path, alert: "Not authorized"
      end
    end

    def show
        if @post
          @comments = @post.comments
        else
          redirect_to posts_path, alert: "Post not found."
        end
      end
      
      

    private
  
    def post_params
        params.require(:post).permit(:title, :content, :image)
    end

    def set_post
        @post = Post.find(params[:id])
        redirect_to posts_path, alert: "Post not found." unless @post
      end
  end
  