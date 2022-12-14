class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google]
  has_many :regions, dependent: :destroy

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)

    user ||= User.create(name: auth.info.name,
                         email: auth.info.email,
                         provider: auth.provider,
                         uid: auth.uid,
                         token: auth.credentials.token,
                         password: Devise.friendly_token[0, 20],
                         meta: auth.to_yaml)
    user
  end
end
