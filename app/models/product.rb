class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  before_save :update_ratio

  field :name, type: String
  field :one_liner, type: String
  field :images, type: String
  field :url, type: String
  field :editor_pick, type: Boolean, default: false
  field :approved, type: Boolean, default: false
  field :display, type: Integer, default: 0
  field :views, type: Integer, default: 0
  field :click, type: Integer, default: 0
  field :d_to_c, type:Float
  field :d_to_v, type:Float

  embeds_many :links
  embeds_many :medias, class_name: "Image"

  validates :name, presence: true
  validates :one_liner, presence: true
  validates :url, presence: true, :url => true

  scope :USA, -> { where('links.country' => 'USA')}
  scope :Canada, ->{where('links.country'=> 'Canada')}
  scope :sort_by_new, -> {order_by(:created_at => :desc)}
  scope :hot, ->{order_by(:d_to_v => :desc)}
  scope :most_viewed, -> {order_by(:views => :desc)}
  scope :editor_pick, ->{where(editor_pick: true)}
  default_scope -> {where(approved: true)}

  def update_ratio
     self.d_to_c = self.click/(self.display+1.0)
     self.d_to_v = self.views/(self.display+1.0)
  end

  def get_previous(country)
     if country=="Canada"
        Product.Canada.sort_by_new.where(:created_at.lt => self.created_at).first
     else
        Product.USA.sort_by_new.where(:created_at.lt => self.created_at).first
    end
  end

  def get_next(country)
    if country=="Canada"
        Product.Canada.sort_by_new.where(:created_at.gt => self.created_at).last
    else
        Product.USA.sort_by_new.where(:created_at.gt => self.created_at).last
    end
  end

  def get_price_range(country)
    if country=="Canada"
        links=self.links.Canada
    else
        links=self.links.USA
    end
    
    if links.empty?
        return "$?"
    end
    lowest = links[0].price
    highest= links[0].price
    links.each do |x|
        if x.price < lowest
            lowest = x.price
        elsif x.price > highest
            highest = x.price
        end
    end
    if lowest==highest 
        return "$"+ '%.2f' %  lowest
    else
        return "$"+ '%.2f' % lowest+" - $"+ '%.2f' % highest
    end
  end
end
