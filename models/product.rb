class Product
	include DataMapper::Resource

	property   :id,        Serial
	property   :delete_at, ParanoidDateTime
	timestamps :at

	property :name,     String
  property :package,  String
	property :amount,   Float
	
	def remove
		self.destroy!
	end

end