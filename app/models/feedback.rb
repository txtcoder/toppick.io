class Feedback
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :message, type: String

  validates :name, presence: true
  validates :message, presence: true
end
