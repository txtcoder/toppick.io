class Admin
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :username, type: String
  field :password_digest, type: String

  has_secure_password

  validates :username, presence: true
  validates :password_digest, presence: true
end
