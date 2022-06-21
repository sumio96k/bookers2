class BookCommentsController < ApplicationController

  def create
  book = Book.find(params[:book_id])
  @comment = current_user.book_comments.new(book_comments_params)
  @comment.book_id = book.id
  @comment.save
  redirect_back(fallback_location: root_path)
  end

  def destroy
    BookComment.find_by(params[:id], book_id: params[:book_id]).destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def book_comments_params
    params.require(:book_comment).permit(:comment)
  end

  def correct_user
    @book = Book.find(params[:book_id])
    redirect_to books_path unless @book.user == current_user
  end

end
