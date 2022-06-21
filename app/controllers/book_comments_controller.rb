class BookCommentsController < ApplicationController

  def create
    #[:book_id]はカラムではなくURLのid
    book = Book.find(params[:book_id])
    #@commentにuser_idとcurrent_user.idの紐づけと送信されてきたデータを格納するインスタンスの作成
    @comment = current_user.book_comments.new(book_comments_params)
    #@commentにBookComentのbook_idと上のbookのid(book.id)を紐づけ
    @comment.book_id = book.id
    #saveメソッドで保存
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
