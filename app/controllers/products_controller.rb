class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :retry]
  before_action :authenticate_user!

  # GET /products
  # GET /products.json
  def index
    @pending = Product.where(parsed: false)
    @failed = Product.where(error: true)
  end

  def parsed
    redirect_to action: :index unless params.has_key? :site_id
    @site = Site.find params[:site_id]
    @products = Product.search(params).page params[:page]
  end

  def retry
    @product.update_attributes! parsed: false, error: false
    FetchProductJob.perform_later @product.id
    redirect_to :back
  end

  # GET /products/1
  # GET /products/1.json
  def show
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

  def add
    @results = { success: [], errors: []}
    params[:list].split.each do |url|
      product = Product.import url
      key = product.errors.none? ? :success : :errors
      @results[key] << product
    end
    flash[:notice] = "Imported #{@results[:success].count} url(s)"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params[:product]
    end
end
