class BookCommentsController < ApplicationController

  before_action :correct_user, only: [:create, :destroy]

  def create
    book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = book.id
    @comment.save
  end

  def destroy
    # BookComment.find_by(params[:id], book_id: params[:book_id]).destroy
    # @book = Book.find(params[:book_id])
    @comment = BookComment.find(params[:id])
    @comment.destroy
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment, :rate)
  end

  def correct_user
    @book = Book.find(params[:book_id])
    redirect_to books_path unless @book.user == current_user
  end

end
