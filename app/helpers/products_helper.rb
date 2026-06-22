module ProductsHelper
  # Renderiza a imagem do produto; se não houver anexo, mostra um bloco com gradiente.
  def product_image(product, css_class:)
    if product.image.attached?
      image_tag product.image, class: css_class, alt: product.name, loading: "lazy"
    else
      tag.div(class: css_class)
    end
  end
end
