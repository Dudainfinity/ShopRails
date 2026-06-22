require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email_address: "cliente@exemplo.com", password: "senha123")
    @product = Product.create!(name: "Monitor", price_cents: 100_000)
    @cart = Cart.create!
    @cart.add_product(@product, quantity: 2)
  end

  test "cria pedido a partir do carrinho com total correto" do
    order = Order.create_from_cart(@cart, user: @user,
              customer_name: "Maria", shipping_address: "Rua A, 123")
    assert_equal 200_000, order.total_cents
    assert_equal 1, order.order_items.count
    assert_equal 2, order.order_items.first.quantity
  end

  test "congela o preço do produto no momento da compra (snapshot)" do
    order = Order.create_from_cart(@cart, user: @user,
              customer_name: "Maria", shipping_address: "Rua A, 123")
    @product.update!(price_cents: 50_000) # preço muda depois
    assert_equal 100_000, order.order_items.first.unit_price_cents
    assert_equal 200_000, order.reload.total_cents
  end

  test "esvazia o carrinho após criar o pedido" do
    Order.create_from_cart(@cart, user: @user,
      customer_name: "Maria", shipping_address: "Rua A, 123")
    assert @cart.reload.empty?
  end

  test "carrinho vazio não gera pedido" do
    vazio = Cart.create!
    assert_raises(ArgumentError) do
      Order.create_from_cart(vazio, user: @user, customer_name: "X", shipping_address: "Y")
    end
  end
end
