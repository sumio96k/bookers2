class BooksController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @book_comment = BookComment.new
    @user = @book.user
  end

  def index
    @books = Book.order(created_at: :DESC)

    @book = Book.new
    @user = current_user

  end

  # def order
  #   orders = params[:orders]
  #   if orders == "new"
  #     @books = Book.order(created_at: :DESC)
  #   elsif orders == "high_rate"
  #     @books = Book.order(rate: :DESC)
  #   end
  # end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
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
    params.require(:book).permit(:title, :body, :rate)
  end

  def correct_user
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user == current_user
  end



end
