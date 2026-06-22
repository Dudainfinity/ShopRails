require "test_helper"

class ShoppingFlowTest < ActionDispatch::IntegrationTest
  setup do
    @product = Product.create!(name: "Teclado Mecânico", price_cents: 34_900,
                               description: "Switches mecânicos")
  end

  test "visitante vê a loja sem precisar de login" do
    get root_path
    assert_response :success
    assert_select "h1"
  end

  test "visitante adiciona produto ao carrinho" do
    assert_difference("CartItem.count", 1) do
      post cart_items_path, params: { product_id: @product.id, quantity: 2 }
    end
    follow_redirect!
    assert_response :success

    get cart_path
    assert_response :success
    assert_select ".cart-row"
  end

  test "checkout exige login" do
    post cart_items_path, params: { product_id: @product.id }
    get new_checkout_path
    assert_redirected_to new_session_path
  end

  test "usuário logado finaliza a compra e gera pedido" do
    sign_in_as(users(:one))
    post cart_items_path, params: { product_id: @product.id, quantity: 3 }

    assert_difference([ "Order.count", "OrderItem.count" ], 1) do
      post checkout_path, params: { order: { customer_name: "Maria", shipping_address: "Rua A, 1" } }
    end

    order = Order.last
    assert_redirected_to order_path(order)
    assert_equal users(:one).id, order.user_id
    assert_equal 3 * 34_900, order.total_cents
  end

  test "checkout sem endereço não cria pedido" do
    sign_in_as(users(:one))
    post cart_items_path, params: { product_id: @product.id }
    assert_no_difference("Order.count") do
      post checkout_path, params: { order: { customer_name: "Maria", shipping_address: "" } }
    end
    assert_response :unprocessable_content
  end

  test "usuário só vê os próprios pedidos" do
    other = users(:two)
    order = Order.create!(user: other, customer_name: "X", shipping_address: "Y", total_cents: 100)

    sign_in_as(users(:one))
    get order_path(order)
    assert_response :not_found
  end
end
