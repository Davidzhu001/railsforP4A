class InstallationsController < ApplicationController
  before_action :set_installation, only: [:show, :edit, :update, :destroy]

  # GET /installations
  # GET /installations.json
  def index
    @installations = Installation.all
  end

  # GET /installations/1
  # GET /installations/1.json
  def show
  end

  # GET /installations/new
  def new
    @installation = Installation.new
    @comment = Comment.new
  end

  # GET /installations/1/edit
  def edit
  end

  # POST /installations
  # POST /installations.json
  def create
    @installation = Installation.new(installation_params)

    respond_to do |format|
      if @installation.save
         @comment = @installation.comments.create(params[:comment].permit(:description, :quantity, :price))
        format.html { redirect_to @installation, notice: 'Installation was successfully created.' }
        format.json { render :show, status: :created, location: @installation }
      else
        format.html { render :new }
        format.json { render json: @installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /installations/1
  # PATCH/PUT /installations/1.json
  def update
    respond_to do |format|
      if @installation.update(installation_params)
        format.html { redirect_to @installation, notice: 'Installation was successfully updated.' }
        format.json { render :show, status: :ok, location: @installation }
      else
        format.html { render :edit }
        format.json { render json: @installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /installations/1
  # DELETE /installations/1.json
  def destroy
    @installation.destroy
    respond_to do |format|
      format.html { redirect_to installations_url, notice: 'Installation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_installation
      @installation = Installation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def installation_params
      params[:installation]
    end
end
