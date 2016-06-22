class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]
  before_action :check_admin, only: [:new, :edit, :create, :update, :destroy]
  # GET /products
  # GET /products.json
  #
  def self.update_display(product_ids)
    product_ids.each do |id|
        product = Product.find(id)
        product.display+=1
        product.save
    end
  end

  def self.update_views(id)
    product= Product.find(id)
    product.views+=1
    product.save
  end

  def self.update_click(id)
    product= Product.find(id)
    product.click+=1
    product.save
  end

  def index
    if params[:sort] && params[:sort]=="new"
        @products = Product.sort_by_new
    elsif params[:sort] && params[:sort]="views"
        @products = Product.most_viewed
    elsif params[:sort] && params[:osrt]="editor"
        @products = Product.editor_pick
    else
       @products = Product.hot 
    end
    filter_by_country()
    product_ids = @products.map{|p| p.id.to_s}
    ProductsController.delay.update_display(product_ids)

    @partial="hot"
    if params[:partial]
        @partial=params[:partial] if %w{hot views editor new}.include? params[:partial]
        render partial: "index", :layout => false
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if params[:external]
        id=@product.id.to_s
        ProductsController.delay.update_click(id)
        redirect_to @product.url
    end
    id = @product.id.to_s
    ProductsController.delay.update_views(id)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
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
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :url, :domain, :price, :images, :country, :specs, :editor_pick)
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
        require 'geoip'
        @geoip ||= GeoIP.new("./db/GeoIP.dat")
        remote_ip = request.remote_ip 
        if remote_ip != "127.0.0.1" #todo: check for other local addresses or set default value
            location_location = @geoip.country(remote_ip)
            if location_location != nil     
                locale = location_location.country_name
            end
        end
        if locale && locale  == "Canada"
            @products=@products.Canada
        else
            @products=@products.USA
        end
            
    end
end
