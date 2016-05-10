class Product
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :domain, type: String
  field :price, type: String
  field :country, type: String
  field :display, type: Integer
  field :views, type: Integer
  field :click, type: Integer
end
