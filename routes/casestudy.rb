
get '/casestudies/cs_index_purch/?' do
    
  @casestudies = Casestudy.all
    
  erb :'/casestudies/cs_index_purch'
end

get '/casestudies/cs_index/?' do
	authorize!
	expired?
  
  @user = User.get session[:user]
  
  @casestudies = Casestudy.all
  @caseaverages = Caseaverage.all(user_id: session[:user], set: params[:set])
    
  erb :'/casestudies/cs_index'
end

get '/casestudies/:set/setscore/?' do
	authorize!
	expired?
  
  @user = User.get session[:user]
  
	@casescores = []
	casescores = Casescore.all(user_id: session[:user])
	casescores.each {|s| @casescores << s.caseanswer_id }
  
  @casestudies = Casestudy.all(set: params[:set])
  @casequestions = @casestudies.casequestions.all(:order => :position)
  @caseanswers = @casequestions.caseanswers.all(:order => :position)
  @caseaverage = Caseaverage.all(user_id: session[:user])
  
    sum = 0
    @caseaverages = Caseaverage.each do  |s|
      if s.set == params[:set] && s.user.id == session[:user]
        sum += s.score
        @setscore = sum/12
      end
    end
    
    @total1 = 0
    @total2 = 0
    @total4 = 0
    @total5 = 0
    @total6 = 0
   
    @casequestions = @casestudies.casequestions.each do |cq|
      if cq.domain == "Domain 1. Professional Practice and Ethics"
        @total1 += 1
      elsif cq.domain == "Domain 2. Intake, Assessment, and Diagnosis"
        @total2 += 1
      elsif cq.domain == "Domain 4. Treatment Planning"
        @total4 += 1
      elsif cq.domain == "Domain 5. Counseling Skills and Interventions"
        @total5 += 1
      else cq.domain == "Domain 6. Core Counseling Attributes"
        @total6 += 1
      end
    end
      
   
      
    @correct1 = 0
    @correct2 = 0
    @correct4 = 0
    @correct5 = 0
    @correct6 = 0
    
  	@casequestions = @casestudies.casequestions.each do |cq|
      if cq.domain == "Domain 1. Professional Practice and Ethics"
        cq.caseanswers.each do |caseanswer|  
          if @casescores.include?(caseanswer.id) && (caseanswer.correct == "true")
            @correct1 += 1
          end
        end 
      elsif cq.domain == "Domain 2. Intake, Assessment, and Diagnosis"
        cq.caseanswers.each do |caseanswer|  
          if @casescores.include?(caseanswer.id) && (caseanswer.correct == "true")  
            @correct2 += 1
          end
        end 
      elsif cq.domain == "Domain 4. Treatment Planning"
        cq.caseanswers.each do |caseanswer|
          if @casescores.include?(caseanswer.id) && (caseanswer.correct == "true")
            @correct4 += 1
          end
        end 
      elsif cq.domain == "Domain 5. Counseling Skills and Interventions"
        cq.caseanswers.each do |caseanswer|
          if @casescores.include?(caseanswer.id) && (caseanswer.correct == "true")
            @correct5 += 1
          end
        end 
      else cq.domain == "Domain 6. Core Counseling Attributes"
        cq.caseanswers.each do |caseanswer|
          if @casescores.include?(caseanswer.id) && (caseanswer.correct == "true")
            @correct6 += 1
          end
        end 
      end
    end
    
  erb :'/casestudies/setscore'
end

get '/casestudies/sample/?' do
	unless session[:user]
		user = User.create(email: 'sample', password: 'sample')
		session[:user] = user.id
		session[:sample] = true
	end
	redirect '/casestudies/1'
end


get '/casestudies/:id/?' do
  expired? 
  
  if @casestudies = Casestudy.sample
    sample = true
  else
    authorize!
  end
  
  @user = User.get session[:user]
  @casestudies = Casestudy.get params[:id]    
  @charts = @casestudies.charts.all(:order => :part)
  @casequestions = @casestudies.casequestions.all(:order => :position)
  @caseanswers = @casequestions.caseanswers.all(:order => :position)
  @casescores = Casescore.all
  
  erb :'casestudies/csexam'
end

post '/casestudies/:id/?' do 
	expired?

  user = User.get session[:user]

  casestudies = Casestudy.get params[:id]
  charts = casestudies.charts.all(:order => :part)
  casequestions = casestudies.casequestions.all(:order => :position)
  caseanswers = casequestions.caseanswers.all(:order => :position)
  casescores = Casescore.all(user_id: session[:user])
 
  
  caseanswers = params.filter {|key, value| key.include?("optionsRadios") }.map { |casequestion, caseanswer| caseanswer.sub!("option", "").to_i }
 
  caseanswers.each { |caseanswer_id| 
    Casescore.create(
      user_id:          session[:user],
      casestudy_id:     params[:id],
      caseanswer_id:    caseanswer_id
    )
  }
  
  redirect "/casestudies/#{params[:id]}/score"
end

get '/casestudies/:id/score/?' do

	expired?
  
  @user = User.get session[:user]
  
	@casescores = []
	casescores = Casescore.all(user_id: session[:user])
	casescores.each {|s| @casescores << s.caseanswer_id }
    
  @casestudies = Casestudy.get params[:id]
  @charts = @casestudies.charts.all
  @casequestions = @casestudies.casequestions.all(:order => :position)
  @caseanswers = @casequestions.caseanswers.all(:order => :position)
  
  
	@counter = 0
	@casequestions.caseanswers.each do |caseanswer|
		if @casescores.include?(caseanswer.id) && caseanswer.correct == "true"
		  caseanswer.id 
      @counter += 1
    end
	end 
  
  
  @title = @casestudies.title.to_i
  @set = @casestudies.set
  
  @percent = (@counter * 100) / 13
  
  Caseaverage.first_or_create(casestudy_id: params[:id], user_id: session[:user], score: @percent, title: @title, set: @set)
  
  
  erb :'casestudies/score'
end

get '/casestudies/:id/caserestart/?' do
	
	expired?

	Casescore.all(user_id: session[:user], casestudy_id: params[:id]).destroy
  Caseaverage.all(user_id: session[:user], casestudy_id: params[:id]).destroy
  
	redirect "/casestudies/#{params[:id]}"
end

get '/casestudies/:id/finished/?' do
	
	Casescore.all(user_id: session[:user], casestudy_id: params[:id]).destroy
  Caseaverage.all(user_id: session[:user], casestudy_id: params[:id]).destroy

  User.all(id: session[:user]).destroy
  
  session[:user] 	 = nil
	session[:admin]  = nil
  
	session[:sample] = nil
	session.clear
    
	redirect "/ncmhce"
end


