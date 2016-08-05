class Link
  include Mongoid::Document
  field :url, type: String
  field :domain, type: String
  field :country, type: String
  field :price, type: Float
  field :product_id, type:Integer
  embedded_in :product

  before_validation :strip_url_parameters

  scope :USA, -> {where(country: "USA")}
  scope :Canada, -> {where(country: "Canada")}

  validates :url, presence: true, :url => true
  validates :domain, presence: true
  validates :price, presence: true
  validates :country, presence: true, inclusion: { in: %w(USA Canada Test), message: "%{value} is not a supported country" }


  def strip_url_parameters
    domain=URI.parse(url).host
    self.domain=domain
    #maybe remove this line for ebay?
    self.url=url.gsub(/\?.*/, "")
  end
end
