class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  before_validation :update_affiliate_link
  before_save :update_ratio

  field :name, type: String
  field :one_liner, type: String
  field :description, type: String
  field :url, type: String
  field :domain, type: String
  field :images, type: String
  field :price, type: String
  field :country, type: String
  field :specs, type: String
  field :editor_pick, type: Boolean, default: false
  field :display, type: Integer, default: 0
  field :views, type: Integer, default: 0
  field :click, type: Integer, default: 0
  field :d_to_c, type:Float
  field :d_to_v, type:Float

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
  scope :hot, ->{order_by(:d_to_v => :desc)}
  scope :most_viewed, -> {order_by(:views => :desc)}
  scope :editor_pick, ->{where(editor_pick: true)}


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

  def update_ratio
     self.d_to_c = self.click/(self.display+1.0)
     self.d_to_v = self.views/(self.display+1.0)
  end
end
