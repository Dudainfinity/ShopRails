class CheckoutController < ApplicationController
  # Checkout exige login (autenticação padrão do ApplicationController).
  before_action :ensure_cart_not_empty

  def new
    @cart = current_cart
    @order = Order.new(customer_name: Current.user.email_address.split("@").first)
  end

  def create
    order = Order.create_from_cart(
      current_cart,
      user: Current.user,
      customer_name: params.dig(:order, :customer_name),
      shipping_address: params.dig(:order, :shipping_address)
    )
    redirect_to order_path(order), notice: "Pedido realizado com sucesso!"
  rescue ActiveRecord::RecordInvalid
    @cart = current_cart
    @order = Order.new(order_params)
    @order.valid?
    render :new, status: :unprocessable_content
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :shipping_address)
  end

  def ensure_cart_not_empty
    redirect_to cart_path, alert: "Seu carrinho está vazio." if current_cart.empty?
  end
end
