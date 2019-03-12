 class User < ActiveRecord::Base
  has_many :messages
  has_many :comments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :send_mail

  def send_mail
  	UserMailer.welcome_email(self).deliver
  end

end
