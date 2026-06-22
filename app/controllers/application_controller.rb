class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_cart

  private

  # Carrinho da sessão atual: funciona para visitantes (sem login).
  # O id fica na sessão; o registro é criado sob demanda na primeira adição.
  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if session[:cart_id] && (cart = Cart.find_by(id: session[:cart_id]))
      cart
    else
      cart = Cart.create!
      session[:cart_id] = cart.id
      cart
    end
  end
end
