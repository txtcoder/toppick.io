class Image
  include Mongoid::Document
  field :img, type: String
  field :product_id, type: Integer
  embedded_in :product
end
