json.products @products do |product|
  json.partial! 'product', product: product
end
json.meta do
  json.pagy do
    json.count @pagy.count
    json.page @pagy.page
    json.pages @pagy.pages
  json.items @pagy.vars[:items]
  end
end
