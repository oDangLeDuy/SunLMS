class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @book = Book.find_by(id: params[:book_id])
    @comment = @book.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = t(:create_complete)
    else
      @feed_items = []
      flash[:danger] = t(:create_fails)
    end
    redirect_to @book
  end

  def destroy
    @comment.destroy
    flash[:success] = t(:delete_complete)
    redirect_to request.referrer || current_user
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :picture)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to request.referrer if @comment.nil?
  end
end
