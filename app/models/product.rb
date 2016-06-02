class Product
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :domain, type: String
  field :images, type: String
  field :price, type: String
  field :country, type: String
  field :display, type: Integer, default: 0
  field :views, type: Integer, default: 0
  field :click, type: Integer, default: 0

  validates :name, presence: true
  validates :description, presence: true
  validates :url, presence: true, :url => true
  validates :domain, presence: true, :url => true
  #validates :images, :url => true
  #validates :price, :presence: true
  #validates :country, :presence: true, inclusion: { in: %w(USA Canada Test), message: "%{value} is not a supported country" }
end
