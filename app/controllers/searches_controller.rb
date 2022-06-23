class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model,@content,@method)
  end

  private

  def search_for(model,content,method)
    if model == "user"
      if method == "perfect"
        User.where(name: content)
      elsif method == "forward"
        User.where("name LIKE?", "#{content}%")
      elsif method == "backward"
        User.where("name LIKE?", "%#{content}")
      elsif method == "patial"
        User.where("name LIKE?", "%#{content}%")
      else
        User.all
      end

  else
      if method == "perfect"
        Book.where(title: content)
      elsif method == "forward"
        Book.where("title LIKE ?", "#{content}%")
      elsif method == "backward"
        Book.where("title LIKE ?", "%#{content}")
      elsif method == "patial"
        Book.where("name LIKE?", "%#{content}%")
      else
        Book.all
      end
    end
  end



 

end
