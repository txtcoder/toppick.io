class Image
  include Mongoid::Document
  field :img, type: String
  embedded_in :product
end
