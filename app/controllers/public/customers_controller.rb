class Public::CustomersController < ApplicationController
  def show
    @customer=current_customer
  end

  def edit
    @customer=current_customer
  end

  def update
    customer=current_customer
    customer.update(customer_params)
    redirect_to customers_my_page_path
  end

  def unsubscribe
    @customer=current_customer
  end

  def withdraw
    @customer=current_customer
    @customer.update(is_active: false)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private
  def customer_params
    params.require(:customer).permit(:id, :first_name, :last_name, :first_name_kana, :last_name_kana, :postal_code, :address, :telephone_number, :email, :is_activ)
  end
end
