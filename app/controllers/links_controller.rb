class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :new, :edit, :create, :update, :destroy, :index]
  before_action :check_admin, only: [:edit, :new, :create, :update, :destroy]
  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
    url = @link.url
    res = Affiliate.find_by( domain: @link.domain, source: get_referral)
    unless res
        res = Affiliate.find_by( domain: @link.domain, source: "original")
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

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    @link.product=@product
    respond_to do |format|
      if @link.save
        format.html { redirect_to @product, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @product, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to @product, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    def set_product
      @product = Product.unscoped.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url, :price, :country)
    end

    def check_admin
        unless logged_in?
        flash[:danger] = "You shouldn't be here"
        redirect_to root_path
        end
    end

end