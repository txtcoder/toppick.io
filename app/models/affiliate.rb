class Affiliate
  include Mongoid::Document
  include Mongoid::Timestamps


  field :domain, type: String
  field :referral, type: String
  field :count, type: Integer
  field :totalvisit, type: Integer
end
