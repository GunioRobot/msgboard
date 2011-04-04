class Message < ActiveRecord::Base
  
  validates_presence_of :content
  belongs_to :user
  has_one :response
end
