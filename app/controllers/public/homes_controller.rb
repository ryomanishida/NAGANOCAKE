class Public::HomesController < ApplicationController

  def top
    @item=Item.page(params[:page]).per(4)
  end
end
