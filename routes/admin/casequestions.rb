get '/admin/casestudies/:id/casequestions?' do
	admin!
  @casestudies = Casestudy.get params[:casestudy_id]
	@casequestions = @casestudies.casequestions.all 

	erb :'admin/casequestions'
end


get '/admin/casestudies/:id/casequestions/new/?' do
	admin!
  @casestudies = Casestudy.get params[:id]
	@casequestions = @casestudies.casequestions.new

	erb :'admin/casequestion_new'
end

post '/admin/casestudies/:id/casequestions/new/?' do
	admin!
  casestudies = Casestudy.get params[:id]
  casequestions = casestudies.casequestions.create(
	  casestudy_id: params[:casestudy_id], 
    number:       params[:number],
    part:         params[:part],
    position:     params[:position],
    body:         params[:body],
    domain:       params[:domain],
    sub_domain:   params[:sub_domain],
    discussion:   params[:discussion]
  )
  
	redirect "/admin/casestudies/#{params[:id]}/edit"
end

get '/admin/casestudies/:id/casequestions/:casequestion_id/view/?' do
	admin!
  @casestudies = Casestudy.get params[:id]
	@casequestions = @casestudies.casequestions.get params[:casrquestion_id]

	erb :'admin/casestudy_edit'
end


get '/admin/casestudies/:id/casequestions/:casequestion_id/edit/?' do
	admin!
	@casestudies = Casestudy.get params[:id]
  @casequestions = @casestudies.casequestions.get params[:casequestion_id]

	erb :'admin/casequestion_edit'
end

post '/admin/casestudies/:id/casequestions/:casequestion_id/edit/?' do
	admin!
  casestudies = Casestudy.get params[:id]
  casequestions = casestudies.casequestions.get params[:casequestion_id]
  casequestions.update(
    number:       params[:number],
    part:         params[:part],
    position:     params[:position],
    body:         params[:body],
    domain:       params[:domain],
    sub_domain:   params[:sub_domain],
    discussion:   params[:discussion]
  )
  
	redirect "/admin/casestudies/#{params[:id]}/edit"
  
end

get '/admin/casestudies/:id/casequestions/:casequestion_id/delete/?' do
  admin!
  casestudies = Casestudy.get params[:id]
  casequestions = casestudies.casequestions.get params[:casequestion_id]
  casequestions.destroy
  redirect "/admin/casestudies/#{params[:id]}/edit"
end


