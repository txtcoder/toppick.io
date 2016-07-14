class Affiliate
  include Mongoid::Document
  include Mongoid::Timestamps


  field :domain, type: String
  field :referral, type: String
  field :source, type: String #where the user comes from
  field :count, type: Integer
  field :totalvisit, type: Integer
end
