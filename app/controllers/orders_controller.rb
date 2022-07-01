class OrdersController < ApplicationController

  def index
    @books = Book.orders(params[:orders])
    
  end

end
