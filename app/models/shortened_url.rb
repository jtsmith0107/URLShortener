class ShortenedUrl < ActiveRecord::Base
  belongs_to(
    :submitter,
    :class_name => "User", 
    :foreign_key => :submitter_id,
    :primary_key => :id 
  )
  
  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :short_url_id,
    :primary_key => :id  
  )
  
  
  has_many :visitors, :through => :visits, :source => :user
  
  def self.get_shortened_url_by_url(short_url)
    ShortenedUrl.all.select{|url| url.short_url == short_url}.first
  end
  
  def uniq_visitors
    self.visitors.uniq
  end
  
  def num_clicks
    self.visitors.count
  end
  
  def num_uniques
    uniq_visitors.count
  end
  
  def num_recent_uniques
    uniq_visitors.select{ |visit| visit.timestamp > 10.minutes.ago }
  end
  
  def self.random_code

    url_array = self.all.map do |url|
      url.short_url
    end
    loop do
      new_url = SecureRandom.urlsafe_base64
      return SecureRandom.urlsafe_base64 unless url_array.include?(new_url)
    end 
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(short_url: ShortenedUrl.random_code,
                     long_url: long_url,
                     submitter_id: user.id
                     )
  end
 

  validates :short_url, :presence => true, :uniqueness => true
  validates :long_url, :presence => true, :uniqueness => true
  validates :submitter_id , :presence => true
end