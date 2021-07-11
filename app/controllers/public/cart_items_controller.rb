class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  
  def index
    @cart_items=CartItem.new
    @cart_items=current_customer.cart_items
  end

# カートから数量変更を押したとき
  def update
    cart_items=current_customer.cart_items
    cart_item=cart_items.find_by(item_id: params[:cart_item][:item_id])
    cart_item.update(cart_item_params)
    flash[:notice] = "数量を変更しました"
    redirect_to cart_items_path
  end

  def destroy
    cart_item=current_customer.cart_items.find(params[:id])
    cart_item.destroy
    flash[:alert] = "#{cart_item.item.name}を削除しました"
    redirect_to cart_items_path
  end


  def destroy_all
    cart_items=current_customer.cart_items
    cart_items.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to cart_items_path
  end

# 商品詳細画面から、カートに追加を押したとき
  def create
    @cart_item=CartItem.new(cart_item_params)
    @cart_item.customer_id=current_customer.id
    @cart_items=current_customer.cart_items
    unless @cart_item.amount.nil? #もし@cart_item.amountが空じゃなければ
      @cart_items.each do |cart_item| #同一商品をカートに追加した時
        if cart_item.item_id == @cart_item.item_id
          new_amount = cart_item.amount + @cart_item.amount
          cart_item.update_attribute(:amount, new_amount)
          @cart_item.delete
        end
      end
      @cart_item.save #通常の時
      flash[:notice] = "カートに追加しました"
      redirect_to cart_items_path
    else #空(個数選択)であれば
      @item=Item.find(params[:cart_item][:item_id])
      flash.now[:alert] = "個数を選択してください"
      render ("public/items/show")
    end
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end
