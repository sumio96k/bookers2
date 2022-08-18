class UsersController < ApplicationController

  before_action :correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.all - is_admin
    @user = current_user
    @book = Book.new
  end

  def show
    if User.find(params[:id]).admin? == false
      @user = User.find(params[:id])
      @books = @user.books
      @book = Book.new

    else
      redirect_back(fallback_location: users_path)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(current_user.id)
    else
      # @book = Book.find(params[:id])
      # @books = Book.new
      # @user = @book.user
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction, :admin)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def is_admin
    User.where(admin: true)
  end

end
