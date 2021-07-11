class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy

  enum payment_method: { "クレジットカード": 0, "銀行振込": 1 }
  enum order_status: {"入金待ち": 0,"入金確認": 1,"製作中": 2,"発送準備中": 3, "発送済み": 4}

	def cart_items
		cart.line_items.each do |item|
			item.cart_item_id = nil
			line_items << item
		end
	end

	validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :payment_method, presence: true

end
