class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!
  
  def index
    @items=Item.page(params[:page]).reverse_order
  end

  def show
    @item=Item.find(params[:id])
    @cart_item=CartItem.new
  end
end
