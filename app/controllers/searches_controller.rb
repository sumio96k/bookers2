class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content,@method)
    elsif @model == "book"
      @records = Book.search_for(@content,@method)
    end
  end

  def tag_search
    @content = params[:content]
    if @content.blank?
      flash[:notice] = "!キーワードを入力してください!"
      redirect_back(fallback_location: root_path)
    else
      @records = Book.tag_search_for(@content)
    end
  end


end
