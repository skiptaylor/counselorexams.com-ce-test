class Casestudy
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property :title,        Integer, default: ''
  property :number,       Text,    default: ''
  property :set,          String,  default: ''  
	property :name,         Text, default: ''
  property :age,          Text, default: ''
	property :sex,          Text, default: ''
  property :gender,       Text, default: ''
  property :sexuality,    Text, default: ''
  property :ethnicity,    Text, default: ''
  property :relationship, Text, default: ''
  property :setting,      Text, default: ''
  property :types,        Text, default: ''
  property :problem,      Text, default: ''
  property :diagnosis,    Text, default: ''
  
  property :resources,    Text, default: ''
  
	property :active,	  Boolean, default: false
  property :sample,	  Boolean, default: false
  
  has n, :casequestions,  :constraint => :destroy
  has n, :charts,         :constraint => :destroy
  has n, :casescores,     :constraint => :destroy
  has n, :caseaverages,   :constraint => :destroy

end

class Chart
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property  :part,      Text, default: ''	
  property  :position,  Integer
  
  property :title,  Text, default: ''
  property :body,   Text, default: ''
  
  belongs_to :casestudy

end

class Casequestion
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property  :number,     Integer
  property  :part,       Integer	
  property  :position,   Integer	
  property  :body,       Text, default: ''
  property  :domain,     Text, default: ''
  property  :sub_domain, Text, default: ''

  property  :discussion, Text, default: ''
  
	belongs_to :casestudy,   required: false
	has n,     :caseanswers, :constraint => :destroy
  
	def remove
		self.caseanswers.each {|a| a.remove}
		self.destroy!
	end

end

class Caseanswer
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
  timestamps :at

	property :position, Text,     default: ''
  property :body,     Text,     default: ''
	
  property :correct,	Text,     default: false

	belongs_to :casequestion, required: false
  has n,     :casescores, :constraint => :destroy

end
