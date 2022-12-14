class Message
  include DataMapper::Resource
  
  property   :id,         Serial
  property   :deleted_at, ParanoidDateTime
  timestamps :at
  
  property :body,    Text,    default: ''
  property :casestudies,  Boolean, default: false
  property :nce,     Boolean, default: false
  property :profile, Boolean, default: false
  
end
