class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items=Item.page(params[:page]).reverse_order
  end

  def new
    @item=Item.new
    @genres=Genre.all
  end

  def create
    item=Item.new(item_params)
    if item.save
      redirect_to admin_item_path(item)
    else
      @item=Item.new
      @genres=Genre.all
      render :new
    end
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
    if item.update(item_params)
      redirect_to admin_item_path
    else
      @item=Item.find(params[:id])
      @genres=Genre.all
      render :edit
    end
  end

  private
  def item_params
    params.require(:item).permit(:image, :name, :introduction, :genre_id, :price)
  end

end
