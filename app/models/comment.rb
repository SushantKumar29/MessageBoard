class Comment < ActiveRecord::Base
	validates :content, presence: true
  	belongs_to :message
  	belongs_to :user
  	has_one :picture, :as => :imageable, dependent: :destroy
  	self.per_page = 5
end