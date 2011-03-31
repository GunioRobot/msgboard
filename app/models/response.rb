class Response < ActiveRecord::Base
	validates_presence_of :content
	belongs_to :message
end
