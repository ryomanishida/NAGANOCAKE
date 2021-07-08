class Admin::ItemsController < ApplicationController
  def index
    @items=Item.page(params[:page]).reverse_order
  end

  def new
    @item=Item.new
    @genres=Genre.all
  end

  def create
    item=Item.new(item_params)
    item.save
    redirect_to admin_items_path
  end

  def show
    @item=Item.find(params[:id])
    @genre=@item.genre
  end

  def edit
    @item=Item.find(params[:id])
    @genres=Genre.all
  end

  def update
    item=Item.find(params[:id])
    item.update(item_params)
    redirect_to admin_item_path
  end

  private
  def item_params
    params.require(:item).permit(:image, :name, :introduction, :genre_id, :price)
  end

end
