class BooksController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_tag = @book.tags
    @books = Book.new
    @book_comment = BookComment.new
    @user = @book.user
  end

  def index
    # @books = Book.order(created_at: :DESC)
    @book = Book.new
    @user = current_user
    
    @tag_list = Tag.all
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
    # sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
  end

  def tag_search
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    #受け取った値を,で区切って配列にする
    tag_list = params[:book][:name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end


  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate, :tag, tag_ids: [])
  end

  def correct_user
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user == current_user
  end



end
