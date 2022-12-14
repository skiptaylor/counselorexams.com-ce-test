get '/admin/messages/?' do
  admin!
  
  @messages = Message.all
  
  erb :'admin/messages'
end

post '/admin/messages/?' do
  admin!
  
  message = Message.create(body: params[:body].strip)
  message.update(profile: true) if params[:profile]
  message.update(casestudies: true) if params[:casestudies]
  message.update(nce: true) if params[:nce]
  
  redirect '/admin/messages'
end

get '/admin/messages/:id/delete/?' do
  admin!
  
  message = Message.get(params[:id])
  message.destroy
  
  redirect '/admin/messages'
end
