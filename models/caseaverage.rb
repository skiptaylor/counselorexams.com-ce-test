class Caseaverage
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, DateTime
	timestamps :at

	property :score,  Integer
  property :title,  Integer
  property :set,    String

	belongs_to :user
  belongs_to :casestudy,    required: false
	
  def remove
		self.destroy!
	end

end