class Message < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	belongs_to :user
	has_many :comments, dependent: :destroy
	has_one :picture, :as => :imageable, dependent: :destroy
	self.per_page = 6
end
