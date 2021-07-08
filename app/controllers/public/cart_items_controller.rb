class Public::CartItemsController < ApplicationController
  def index
    @cart_items=CartItem.new
    @cart_items=current_customer.cart_items
  end

# カートから数量変更を押したとき
  def update
    cart_items=current_customer.cart_items
    cart_item=cart_items.find_by(item_id: params[:cart_item][:item_id])
    cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    cart_item=current_customer.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end


  def destroy_all
    cart_items=current_customer.cart_items
    cart_items.destroy_all
    redirect_to cart_items_path
  end

# 商品詳細画面から、カートに追加を押したとき
  def create
    @cart_item=CartItem.new(cart_item_params)
    @cart_item.customer_id=current_customer.id
    @cart_items=current_customer.cart_items
    @cart_items.each do |cart_item|
      if cart_item.item_id == @cart_item.item_id
        new_amount = cart_item.amount + @cart_item.amount
        cart_item.update_attribute(:amount, new_amount)
        @cart_item.delete
      end
    end

    if @cart_item.save
      redirect_to cart_items_path
    else
      @item=Item.find(params[:cart_item][:item_id])
      @cart_item = CartItem.new
      flash[:alert] = "個数を選択してください"
      render :index
    end
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end
