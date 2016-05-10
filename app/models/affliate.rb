class Affliate
  include Mongoid::Document
  field :domain, type: String
  field :referral, type: String
  field :count, type: Integer
  field :totalvisit, type: Integer
end
