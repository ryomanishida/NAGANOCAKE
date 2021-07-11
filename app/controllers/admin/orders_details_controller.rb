class OrdersDetailsController < ApplicationController
  
  def update
  end

  private
  def order_detail_params
    params.require(:order_detail).permit(:id, :item_id, :order_id, :price, :amount)
  end
end
