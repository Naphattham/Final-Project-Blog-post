class CommentsController < ApplicationController
    before_action :authenticate_user! # ตรวจสอบว่าผู้ใช้เข้าสู่ระบบก่อนใช้งาน
    before_action :set_post, only: [:create]
  
    def create
      @comment = @post.comments.build(comment_params.merge(user: current_user))
      if @comment.save
        redirect_to post_path(@post), notice: "Comment added successfully."
      else
        redirect_to post_path(@post), alert: "Failed to add comment. Please try again."
      end
    end
  
    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to post_path(@comment.post), notice: 'Comment was successfully deleted.'
      end
      

    def show
        @comment = Comment.find(params[:id])
    end

    def edit
        @comment = Comment.find(params[:id])
    end
      
     def update
        @comment = Comment.find(params[:id])
        if @comment.update(comment_params)
          redirect_to post_path(@comment.post), notice: 'Comment updated successfully!'
        else
          render :edit, status: :unprocessable_entity
     end
  end
      
      
  
    private
  
    # กำหนดคอมเมนต์ที่อนุญาตให้แก้ไข
    def comment_params
      params.require(:comment).permit(:content)
    end
  
    # หา Post ตาม params[:post_id]
    def set_post
      @post = Post.find(params[:post_id])
    end
  end
  