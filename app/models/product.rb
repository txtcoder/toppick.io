class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  before_validation :update_affiliate_link

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
  validates :domain, presence: true
  validates :price, presence: true
  validates :country, presence: true, inclusion: { in: %w(USA Canada Test), message: "%{value} is not a supported country" }

  scope :test, -> {where(country: "Test")}
  scope :USA, -> {where(country: "USA")}
  scope :Canada, ->{where(country: "Canada")}
  scope :sort_by_new, -> {order_by(:created_at => :desc)}

  def update_affiliate_link
    domain= URI.parse(url).host
    self.domain=domain
    res = Affiliate.find_by( domain: domain)
    if res
        referral = res.referral
        if url.include? referral
            self.url=url
        elsif url.include? "?" and url[-1]!="/"
            self.url = url+"&"+referral
        elsif url.include? "?"
            self.url= url[0..-1]+"&"+referral
        elsif url[-1]!="/"
            self.url=url+"/?"+referral
        else
            self.url=url+"?"+referral
        end
    end
    
  end
end
