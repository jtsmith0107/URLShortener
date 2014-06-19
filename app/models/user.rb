class User < ActiveRecord::Base
  
  def self.select_user(email)
    User.all.select{|user| user.email == email}.first
  end
  
  def self.valid_email?(email)
    User.all.any?{|user| user.email == email}
  end
  
  has_many(
    :submitted_urls,
    :class_name => "ShortenedUrl",
    :foreign_key => :submitter_id,
    :primary_key => :id  
  )
  
  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :visitor_id,
    :primary_key => :id  
  )
  
  has_many :visited_urls, 
            :through => :visits, 
            :source => :short_url          
         
  
  validates :email, :presence => true, :uniqueness => true
end