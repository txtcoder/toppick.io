class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :copy]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update, :copy]
  before_action :check_admin, only: [:new, :edit, :create, :update, :destroy]
  # GET /products
  # GET /products.json
  #
  def self.update_display(product_ids)
    product_ids.each do |id|
        product = Product.find(id)
        if product
            product.display+=1
            product.save
        end
    end
  end

  def self.update_views(id)
    product= Product.find(id)
    if product
        product.views+=1
        product.save
    end
  end

  def self.update_click(id)
    product= Product.find(id)
    if product
        product.click+=1
        product.save
    end
  end

  def index
    unless logged_in?
        redirect_to static_pages_maintenance_path
    end
    if params[:country]
        set_country(params[:country])
    end
    if logged_in?
        @products=Product.unscoped
    elsif params[:sort] && params[:sort]=="new"
        @products = Product.sort_by_new
    elsif params[:sort] && params[:sort]=="views"
        @products = Product.most_viewed
    elsif params[:sort] && params[:sort]=="editor"
        @products = Product.editor_pick
    else
       @products = Product.hot 
    end
    filter_by_country
    product_ids = @products.map{|p| p.id.to_s}
    ProductsController.delay.update_display(product_ids)

    @sort="hot"
    @sort=params[:sort] if %w{hot views editor new}.include? params[:sort]
    if params[:partial]
        render partial: "index", :layout => false
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if params[:external]
        id=@product.id.to_s
        ProductsController.delay.update_click(id)
        url = @product.url
        res = Affiliate.find_by( domain: @product.domain, source: get_referral)
        unless res
            res = Affiliate.find_by( domain: @product.domain, source: "original")
        end
         if res
            referral = res.referral
            tag=referral.split("=")[0]
            content=referral.split("=")[1]
            
            if url.include? tag+"="
                url.gsub(/(#{tag}=).*/, referral)
                
            elsif url.include? "?" and url[-1]!="/"
                url = url+"&"+referral
            elsif url.include? "?"
                url= url[0..-1]+"&"+referral
            elsif url[-1]!="/"
                url=url+"/?"+referral
            else
                url=url+"?"+referral
            end
        end
        redirect_to url
    end
    id = @product.id.to_s
    @links=@product.links
    set_link_country
    ProductsController.delay.update_views(id)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  #GET /products/1/copy
  #:name, :description, :url, :domain, :price, :images, :country, :specs, :editor_pick
  def copy
    temp = Product.new
    temp.name = @product.name
    temp.description = @product.description
    temp.one_liner = @product.one_liner
    temp.images= @product.images
    temp.specs = @product.specs
    temp.editor_pick = @product.editor_pick
    @product = temp
    render :edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.unscoped.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :one_liner, :description, :url, :domain, :price, :images, :country, :specs, :editor_pick, :approved)
    end
    
    def set_s3_direct_post
        @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end

    def check_admin
        unless logged_in?
        flash[:danger] = "You shouldn't be here"
        redirect_to root_path
        end
    end

    def filter_by_country
        if logged_in?
            #do nothing
        elsif get_country  == "Canada"
            @products=@products.Canada
        else
            @products=@products.USA
        end
    end
    def set_link_country
        if get_country == "Canada"
            @links=@links.Canada
        else
            @links=@links.USA
        end
    end
end
