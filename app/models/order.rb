class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :customer_name, :shipping_address, presence: true

  # Cria um pedido a partir de um carrinho, copiando o preço de cada produto
  # (snapshot) para que alterações futuras de preço não afetem pedidos passados.
  # Tudo em uma transação: ou o pedido inteiro é criado, ou nada é.
  def self.create_from_cart(cart, user:, customer_name:, shipping_address:)
    raise ArgumentError, "carrinho vazio" if cart.empty?

    transaction do
      order = create!(
        user: user,
        customer_name: customer_name,
        shipping_address: shipping_address,
        total_cents: cart.total_cents
      )

      cart.cart_items.includes(:product).find_each do |item|
        order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          unit_price_cents: item.product.price_cents
        )
      end

      cart.cart_items.destroy_all
      order
    end
  end

  def total_brl
    Product.format_brl(total_cents)
  end

  def total_items
    order_items.sum(:quantity)
  end
end
