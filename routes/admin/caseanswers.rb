get '/admin/casestudies/:casestudy_id/casequestions/:casequestion_id/caseanswers/new/?' do
	admin!
	@casestudies = Casestudy.get params[:casestudy_id]
  @casequestions = @casestudies.casequestions.get params[:casequestion_id]
  @caseanswers = @casequestions.caseanswers.new
  
  erb :'admin/caseanswers_new'
end
 
post '/admin/casestudies/:casestudy_id/casequestions/:casequestion_id/caseanswers/new/?' do
	admin!
	@casestudies = Casestudy.get params[:casestudy_id]
  @casequestions = @casestudies.casequestions.get params[:casequestion_id]
  @caseanswers = @casequestions.caseanswers.create(
    :position         => params[:position],
    :body             => params[:body],
    :correct          => params[:correct]
  ) 
  
  redirect "/admin/casestudies/#{params[:casestudy_id]}/casequestions/#{params[:casequestion_id]}/edit"
end

get '/admin/casestudies/:casestudy_id/casequestions/:casequestion_id/caseanswers/:caseanswer_id/edit/?' do
	admin!
	@casestudies = Casestudy.get(params[:casestudy_id])
  @casequestions = @casestudies.casequestions.get(params[:casequestion_id])
  @caseanswers = @casequestions.caseanswers.get(params[:caseanswer_id])
  
  erb :'admin/caseanswers_edit'
end

post '/admin/casestudies/:casestudy_id/casequestions/:casequestion_id/caseanswers/:caseanswer_id/edit/?' do
	admin!
	casestudies = Casestudy.get params[:casestudy_id]
  casequestions = casestudies.casequestions.get params[:casequestion_id]
  caseanswers = casequestions.caseanswers.get params[:caseanswer_id]
  caseanswers.update(
    :position         => params[:position],
    :body             => params[:body],
    :correct          => params[:correct]
  )
  
  redirect "/admin/casestudies/#{params[:casestudy_id]}/casequestions/#{params[:casequestion_id]}/edit"
end

get '/admin/casestudies/:casestudy_id/casequestions/:casequestion_id/caseanswers/:caseanswer_id/delete/?' do
	admin!
  casestudies = Casestudy.get params[:casestudy_id]
  casequestions = casestudies.casequestions.get params[:casequestion_id]
  caseanswers = casequestions.caseanswers.get params[:caseanswer_id]
  caseanswers.destroy
  
  redirect "/admin/casestudies/#{params[:casestudy_id]}/casequestions/#{params[:casequestion_id]}/edit"
end
