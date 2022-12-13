class Casescore
  include DataMapper::Resource

  property   :id,         Serial
  property   :deleted_at, DateTime
  timestamps :at
  
  property    :correct, Integer, default: 0
  property    :casequestion_id, Integer, default: 0
  property    :domain,   String
  property    :set,   String
  
  belongs_to :user
  belongs_to :casestudy,  required: false
  belongs_to :caseanswer
  belongs_to :casequestion

  def remove
    self.destroy!
  end

end


