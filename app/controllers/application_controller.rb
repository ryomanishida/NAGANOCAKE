class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

#ログイン後の遷移先
  def after_sign_in_path_for(resource)
    if customer_signed_in?
      customers_my_page_path(resource.id)
    else
      admin_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, :is_active])
  end

end
