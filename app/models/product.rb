class Product < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  # Preço em reais, derivado dos centavos (evita erros de ponto flutuante).
  def price
    price_cents / 100.0
  end

  def price_brl
    self.class.format_brl(price_cents)
  end

  def self.format_brl(cents)
    ActiveSupport::NumberHelper.number_to_currency(
      cents / 100.0, unit: "R$ ", separator: ",", delimiter: "."
    )
  end
end
