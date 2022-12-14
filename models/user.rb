# ALTER TABLE casestudies ALTER COLUMN title TYPE integer USING (title::integer);
# delete from scores where deleted_at IS NOT NULL;
# delete from caseanswers where deleted_at IS NOT NULL;
# delete from casequestions where deleted_at IS NOT NULL;
# delete from users where email = 'sample';

# ALTER TABLE "public"."users" ADD UNIQUE ("email");

# delete from scores where deleted_at IS NOT NULL;
# delete from averages where deleted_at IS NOT NULL;
# delete from uses where delete_at IS NOT NULL;
# delete from users where delete_at IS NOT NULL;
# delete from purchases where delete_at IS NOT NULL;

# ALTER TABLE "public"."users" ADD "TRUE" ("setA");

# Update "public"."users"
# SET set_c = TRUE where max_scenarios = 36

# ALTER TABLE casestudies
#   ALTER COLUMN title TYPE INTEGER USING (char_length(title));
  
  
class User
	include DataMapper::Resource

	property   :id,        Serial
	property   :delete_at, ParanoidDateTime
	timestamps :at

  property :legacy_id, Integer

	property :email,    Text,    unique_index: true
	property :password, BCryptHash

	property :pass_reset_key,	String
	property :pass_reset_date, Date

	property :admin,  Boolean, default: false

	property :name,  				 String
	property :phone, 				 String
  property :license,       String,	 default: ""
	property :hear_about_us, String

	property :notes,	Text

	property :expiration_date, 		 Date, default: Chronic.parse('1 year from now')
	property :refund_request_date, Date
	property :refund_check_date,	 Date

	property :max_exams, 		          Integer, default: 0
	property :max_scenarios,          Integer, default: 0
  property :max_practice_scenarios, Integer, default: 0

	property :setA, 		  Boolean, default: false
  property :setB, 		  Boolean, default: false
  property :setC, 		  Boolean, default: false
  property :setD, 		  Boolean, default: false
  property :hard_copy, 	Boolean, default: false
  
  property :casestudy_downloads,  Boolean, default: false
  property :ncmhce_downloads,     Boolean, default: false
	property :nce_downloads, 		    Boolean, default: false
  
	property :ncmhce_flashcards,  Boolean, default: false
	property :nce_flashcards, 	  Boolean, default: false

	property :workshop_scenarios, Boolean, default: false
  property :practice_exams, Boolean, default: false

  has n, :scores,       :constraint => :destroy
  has n, :casescores,   :constraint => :destroy
	has n, :averages,     :constraint => :destroy
	has n, :purchases,    :constraint => :destroy
  has n, :caseaverages, :constraint => :destroy

	def remaining_exams
		self.max_exams - Use.all(user_id: self.id, :exam_id.not => nil).count
	end
   
	def remaining_scenarios
		used = 0
		Use.all(user_id: self.id, :scenario_id.not => nil, :sample => false).each do |use|
			used = used + 1 unless use.scenario.practice? || use.scenario.workshop?
		end
		self.max_scenarios - used
	end
  
	def remaining_practice_scenarios
		used = 0
		Use.all(user_id: self.id, :scenario_id.not => nil, :sample => false).each do |use|
			used = used + 1 if use.scenario.practice? unless use.scenario.workshop?
		end
		self.max_practice_scenarios - used
	end
  
  def remove_sample
    Use.all(user_id: self.id).destroy
    self.averages.each {|a| a.remove}
    self.purchases.each {|p| p.remove}
    self.scores.each {|s| s.remove}
    self.destroy!
  end
	
	def expired?
		self.expiration_date < DateTime.now
	end
  
  def remove
    self.averages.each {|a| a.remove}
    self.purchases.each {|p| p.remove}
    self.scores.each {|s| s.remove}
    self.destroy!
  end
end
