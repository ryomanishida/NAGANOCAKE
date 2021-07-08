class Public::OrdersController < ApplicationController
  def new
    @order=Order.new
    @current_address = current_customer.postal_code + current_customer.address + current_customer.first_name + current_customer.last_name
    @cart_items = current_customer.cart_items
    @addresses = current_customer.addresses
  end

  def confirm
    @cart_items = CartItem.new
    @cart_items = current_customer.cart_items
    @order = Order.new
    @order.payment_method = params[:order][:payment_method].to_i
    @order.customer_id = current_customer.id
    if params[:address_selection] == 'radio1'
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.first_name
    elsif params[:address_selection] =='radio2'
      address = params[:order][:address_id]
      address = Address.find(address)
      @order.postal_code = address.postal_code
      @order.address = address.address
      @order.name = address.name
    elsif params[:address_selection] == 'radio3'
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end
    # render :new if @order.invalid?
  end

  def create
    @order=Order.new(order_params)
    @order.customer_id = current_customer.id
    if @order.save
      redirect_to orders_complete_path
    #カートアイテムをorder_detail格納 (order_detail_params)はorder_detailの情報を制約かけるわけではないのでいらない
      @cart_items = current_customer.cart_items
      @cart_items.each do |cart_item|
        @order_detail = OrderDetail.new
        @order_detail.item_id = cart_item.item.id
        @order_detail.order_id = @order.id
        @order_detail.price = cart_item.item.price
        @order_detail.amount = cart_item.amount
        @order_detail.save
      end
    #注文完了後カートをクリア
      current_customer.cart_items.destroy_all
    else
      render :new
    end
  end

  def index
    @orders=current_customer.orders
  end

  def show
    @order=Order.find(params[:id])
    @order.customer_id = current_customer.id
  end

  private
  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :shipping_cost, :total_payment, :customer_id, :payment_method, :id)
  end
end
