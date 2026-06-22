# Popula a loja com produtos de demonstração e suas imagens.
# Idempotente: pode rodar várias vezes sem duplicar.

IMAGES_DIR = Rails.root.join("db", "seed_images")

products = [
  { name: "Teclado Mecânico RGB",   price_cents: 34_900, image: "teclado.png",
    description: "Switches mecânicos, iluminação RGB por tecla e estrutura em alumínio. Ideal para quem digita e joga por horas." },
  { name: "Mouse Gamer 16.000 DPI", price_cents: 19_900, image: "mouse.png",
    description: "Sensor óptico de alta precisão, 7 botões programáveis e peso ajustável." },
  { name: "Monitor 27\" QHD 165Hz", price_cents: 169_900, image: "monitor.png",
    description: "Painel IPS 2560x1440, 165Hz e 1ms. Cores fiéis e movimento fluido." },
  { name: "Headset 7.1 Surround",   price_cents: 27_900, image: "headset.png",
    description: "Som surround 7.1, microfone com cancelamento de ruído e espumas memory foam." },
  { name: "Webcam Full HD 1080p",   price_cents: 22_900, image: "webcam.png",
    description: "Vídeo 1080p a 60fps, foco automático e correção de luz. Perfeita para calls e lives." },
  { name: "Cadeira Ergonômica Pro", price_cents: 89_900, image: "cadeira.png",
    description: "Apoio lombar ajustável, encosto reclinável e apoios de braço 4D." },
  { name: "SSD NVMe 1TB",           price_cents: 49_900, image: "ssd.png",
    description: "Leitura de até 7.000 MB/s. Boot e carregamentos quase instantâneos." },
  { name: "Microfone Condensador",  price_cents: 39_900, image: "microfone.png",
    description: "Captação cardioide em qualidade de estúdio, com tripé e filtro pop." }
]

products.each do |attrs|
  image = attrs.delete(:image)
  product = Product.find_or_initialize_by(name: attrs[:name])
  product.assign_attributes(attrs)
  product.save!

  path = IMAGES_DIR.join(image)
  if path.exist? && !product.image.attached?
    product.image.attach(io: File.open(path), filename: image, content_type: "image/png")
  end
end

puts "Produtos: #{Product.count} | com imagem: #{Product.all.count { |p| p.image.attached? }}"
