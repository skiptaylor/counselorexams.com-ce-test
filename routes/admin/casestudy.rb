get '/admin/casestudies/?' do
	admin!
	@casestudies = Casestudy.all
  @charts = @casestudies.charts.all
  @casequestions = @casestudies.casequestions.all
	erb :'admin/casestudies'
end


get '/admin/casestudies/:id/view/?' do
	admin!
	@casestudies = Casestudy.get params[:id]
  @charts = @casestudies.charts.all
  @casequestions = @casestudies.casequestions.all

	erb :'admin/casestudy_view'
end


get '/admin/casestudies/new/?' do
	admin!
	@casestudies = Casestudy.new
  
	erb :'admin/casestudy_edit'
end

post '/admin/casestudies/new/?' do
	admin!
  
  casestudies = Casestudy.create(
		:number         => params[:number],
    :title          => params[:title],
    :name           => params[:name],
    :age            => params[:age],
    :sex            => params[:sex],
    :gender         => params[:gender],
    :sexuality      => params[:sexuality],
    :ethnicity      => params[:ethnicity],
    :relationship   => params[:relationship],
    :setting        => params[:setting],
    :types          => params[:types],
    :problem        => params[:problem],
    :diagnosis      => params[:diagnosis],
    :resources      => params[:resources],
    :set            => params[:set]
	)
  params[:active]     ? casestudies.update(:active => true)     : casestudies.update(:active => false)
  params[:sample]     ? casestudies.update(:sample => true)     : casestudies.update(:sample => false)
  
	session[:alert] = { style: 'alert-success', message: "New Case Study Created." }
	redirect "/admin/casestudies"
end

get '/admin/casestudies/:id/edit/?' do
	admin!
	@casestudies = Casestudy.get params[:id]
  @charts = @casestudies.charts.all
  @casequestions = @casestudies.casequestions.all
  
	erb :'admin/casestudy_edit'
end

post '/admin/casestudies/:id/edit/?' do
	admin!
  
  casestudies = Casestudy.get params[:id]
  charts = casestudies.charts.all
  casequestions = casestudies.casequestions.all
	casestudies.update(
	  :number         => params[:number],
    :title          => params[:title],
    :name           => params[:name],
    :age            => params[:age],
    :sex            => params[:sex],
    :gender         => params[:gender],
    :sexuality      => params[:sexuality],
    :ethnicity      => params[:ethnicity],
    :relationship   => params[:relationship],
    :setting        => params[:setting],
    :types          => params[:types],
    :problem        => params[:problem],
    :diagnosis      => params[:diagnosis],
    :resources      => params[:resources],
    :set            => params[:set]
	)
  params[:active]     ? casestudies.update(:active => true)     : casestudies.update(:active => false)
  params[:sample]     ? casestudies.update(:sample => true)     : casestudies.update(:sample => false)
  
	session[:alert] = { style: 'alert-success', message: "Case Study Updated." }
	redirect "/admin/casestudies/#{params[:id]}/view"
end

get '/admin/casestudies/:id/delete/?' do
  admin!
  @casestudies = Casestudy.get params[:id]
  @casestudies.destroy
  redirect "/admin/casestudies"
end




