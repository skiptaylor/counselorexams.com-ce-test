get '/admin/products/?' do
	admin!
	@products = Product.all
  
	erb :'admin/products'
end


get '/admin/products/new/?' do
	admin!
	@products = Product.new
  
	erb :'admin/product_new'
end

post '/admin/products/new/?' do
	admin!
	products = Product.create(
		name:     params[:name],
    package:  params[:package],
		amount:   params[:amount]
	)
  
	redirect "/admin/products"
end

get '/admin/products/:id/edit/?' do
  admin!
  @products = Product.get(params[:id])
  
  erb :'admin/product_edit'
end

post '/admin/products/:id/edit/?' do
  admin!
  products = Product.get(params[:id])
	products.update(
	  name:     params[:name],
    package:  params[:package],
	  amount:   params[:amount]
	)
  
  redirect "/admin/products/"
end

get '/admin/products/:id/delete/?' do
	admin!
	@products = Product.get(params[:id])
  @products.destroy
	
	redirect "/admin/products/"
end