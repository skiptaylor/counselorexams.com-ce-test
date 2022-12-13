get '/checkout/:product/?' do
	@product_name = ''
	case params[:product]
  when 'nce'
    @product_name = "Dr. Arthur's NCE Study Program"
  when 'nce-upgrade'
    @product_name = "Dr. Arthur's NCE Study Program"
  when 'nce-hard-copy'
    @product_name = "Dr. Arthur's NCE Study Guide"

  when 'starter-package-a'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'starter-package-b'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'starter-package-c'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'starter-package-d'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'package-a'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'package-b'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'package-c'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
  when 'package-d'
    @product_name = "Dr. Arthur's NCMHCE Case Study Program"
	when 'ncmhce-hard-copy'
		@product_name = "Dr. Arthur's NCMHCE Overview"
  when 'second-chance-upgrade'
		@product_name = "Dr. Arthur's NCMHCE Case Study Program"

	when 'account-extension'
		@product_name = "Extend Your Account"
	when 'account-expiration'
		@product_name = "Extend Your Account"
		unless @user = User.first(email: params[:account])
			session[:alert] = { message: "Your account has expired." }
			redirect('/sign-in')
		end
	end

	unless @user
		@user = User.get(session[:user]) if session[:user]
	end

	erb :'checkout/index'
end

post '/checkout/:product/?' do

  unless params[:user_id]
		params[:email].strip!
		params[:email].downcase!
		params[:password].strip!
		params[:password].downcase!
  end
	params[:name] = "#{params[:first_name]} #{params[:last_name]}"
	params[:address1].strip!
	params[:address2].strip!
	params[:city].strip!
	params[:state].strip!
	params[:zip].strip!
	
  if params[:user_id]
		user = User.get params[:user_id]
		params[:email] = user.email
  else
		user = User.new(email: params[:email],
		                password: params[:password],
                        name: params[:name],
                   max_exams: 0,
                        setA: false,
                        setB: false,
                        setC: false,
                        setD: false,
                   hard_copy: false,
               nce_downloads: false,
         casestudy_downloads: false,
              nce_flashcards: false
    )
  end  

  case params[:package]
  when 'Basic Package'
    user.nce_downloads = true
    user.nce_flashcards = true
    user.max_exams = (user.max_exams + 2)
    params[:package] = 'NCE: Basic Package'
               email = 'nce'
                 msg = true

  when 'Enhanced Package'
    user.nce_downloads = true
    user.nce_flashcards = true
    user.max_exams = (user.max_exams + 4)
    params[:package] = 'NCE: Enhanced Package'
               email = 'nce'
                 msg = true

  when 'Starter Package SetA'
    user.casestudy_downloads = true
           user.setA = true
    params[:package] = 'NCMHCE: Starter Package SetA'
               email = 'ncmhce'
                 msg = true
    
  when 'Starter Package SetB'
    user.casestudy_downloads = true
           user.setB = true
    params[:package] = 'NCMHCE: Starter Package SetB'
               email = 'ncmhce'
                 msg = true
    
  when 'Starter Package SetC'
    user.casestudy_downloads = true
           user.setC = true
    params[:package] = 'NCMHCE: Starter Package SetC'
               email = 'ncmhce'
                 msg = true
    
  when 'Starter Package SetD'
    user.casestudy_downloads = true
           user.setD = true
    params[:package] = 'NCMHCE: Starter Package SetD'
               email = 'ncmhce'
                 msg = true
    
  when 'Package SetA'
    user.casestudy_downloads = true
           user.setA = true
    params[:package] = 'NCMHCE: Package SetA'
               email = 'ncmhce'
                 msg = true
    
  when 'Package SetB'
    user.casestudy_downloads = true
           user.setB = true
    params[:package] = 'NCMHCE: Package SetB'
               email = 'ncmhce'
                 msg = true
    
  when 'Package SetC'
    user.casestudy_downloads = true
           user.setC = true
    params[:package] = 'NCMHCE: Package SetC'
               email = 'ncmhce'
                 msg = true
    
  when 'Package SetD'
    user.casestudy_downloads = true
           user.setD = true
    params[:package] = 'NCMHCE: Package SetD'
               email = 'ncmhce'
                 msg = true

  when 'Full Package'
    user.casestudy_downloads = true
    user.setA = true
    user.setB = true
    user.setC = true
    user.setD = true
    params[:package] = 'NCMHCE: Full Package'
               email = 'ncmhce'
                 msg = true

  when 'Second Chance Upgrade'
    user.casestudy_downloads = true
    user.setA = true
    user.setB = true
    user.setC = true
    user.setD = true
      params[:package] = 'NCMHCE: Second Chance Upgrade'
                   msg = false

  when 'NCE Upgrade'
    user.max_exams = (user.max_exams + 2)
    params[:package] = 'NCE: Upgrade'
                 msg = false

  when 'NCE Hard Copy'
    params[:package] = 'NCE: Hard Copy'
                 msg = false

  when 'NCMHCE Hard Copy'
        user.hard_copy = true
      params[:package] = 'NCMHCE: Hard Copy'
             	     msg = false
                 
  when 'Account Extension'
    params[:package] = 'Account Extension'
                 msg = false
    
  when 'Account Expiration'
    params[:package] = 'Account Expiration'
                 msg = false
  end
  
  case params[:hard_copy]
  when 'NCMHCE Hard Copy'
    user.hard_copy = true
    params[:hard_copy] = 'NCMHCE: Hard Copy'
	             msg = false
  end
  
  
  if params[:user_id]
		if (params[:package] == 'Account Extension')
			user.expiration_date = (user.expiration_date + 90)
    elsif (params[:package] == 'Account Expiration')
      user.expiration_date = (DateTime.now + 90)
  	elsif (params[:package] == 'NCMHCE: Hard Copy') || (params[:package] == 'NCMHCE: Second Chance Upgrade') || (params[:hard_copy] == 'NCMHCE Hard Copy')
  		user.expiration_date = (user.expiration_date + 0)
		else
			user.expiration_date = (DateTime.now + 365)
		end
    user.save
    
  end
  
  Stripe.api_key = STRIPE_PRIVATE_KEY
  
  if charge = Stripe::Charge.create(amount: (params[:amount].to_f * 100).to_i,
                               currency: "usd",
                                   card: params[:stripeToken],
                            description: "#{params[:name]} (#{params[:email]}) #{params[:package]}") 
    user.save
  	user.purchases.create(package: params[:package],
  		                    options: params[:optional],
                        stripe_id: charge.id,
                           amount: params[:amount],
                         address1: params[:address1],
                         address2: params[:address2],
                             city: params[:city],
                            state: params[:state],
                              zip: params[:zip])
      
    if settings.environment == 'production'
      unless user.purchases.count > 1 
       if (params[:package] == 'NCMHCE: Starter Package SetA') || (params[:package] == 'NCMHCE: Starter Package SetB') || (params[:package] == 'NCMHCE: Starter Package SetC') || (params[:package] == 'NCMHCE: Starter Package SetD') || (params[:package] == 'NCMHCE: Full Package')
         
         Email.welcome(user.email, user.name, user.email, email, "#{params[:package]}", params[:amount])
         Email.secondchance(user.email, user.name)
       # else
       #   Email.welcome(user.email, user.name, user.email, email, "#{params[:package]}", params[:amount])
       end
     end
    end
    
    sign_in user.id, msg: msg
  else
    session[:alert] = { style: 'alert-error',
                      message: "There was an error charging your card. Please call support at 888-326-9229, Monday - Friday, 9:00 AM - 5:00 PM EST." }
    redirect request.referrer
  end
end