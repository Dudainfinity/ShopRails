class OrdersController < ApplicationController
  # Apenas pedidos do usuário logado (escopo de segurança).
  def index
    @orders = Current.user.orders.order(created_at: :desc)
  end

  def show
    @order = Current.user.orders.find(params[:id])
    @order_items = @order.order_items.includes(product: { image_attachment: :blob })
  end
end
