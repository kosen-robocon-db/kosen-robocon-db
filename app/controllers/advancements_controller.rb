class AdvancementsController < ApplicationController
  before_action :set_advancement, only: [:show, :edit, :update, :destroy]

  # GET /advancements
  # GET /advancements.json
  def index
    @advancements = Advancement.all
  end

  # GET /advancements/1
  # GET /advancements/1.json
  def show
  end

  # GET /advancements/new
  def new
    @advancement = Advancement.new
  end

  # GET /advancements/1/edit
  def edit
  end

  # POST /advancements
  # POST /advancements.json
  def create
    @advancement = Advancement.new(advancement_params)

    respond_to do |format|
      if @advancement.save
        format.html { redirect_to @advancement, notice: 'Advancement was successfully created.' }
        format.json { render :show, status: :created, location: @advancement }
      else
        format.html { render :new }
        format.json { render json: @advancement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advancements/1
  # PATCH/PUT /advancements/1.json
  def update
    respond_to do |format|
      if @advancement.update(advancement_params)
        format.html { redirect_to @advancement, notice: 'Advancement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advancement }
      else
        format.html { render :edit }
        format.json { render json: @advancement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advancements/1
  # DELETE /advancements/1.json
  def destroy
    @advancement.destroy
    respond_to do |format|
      format.html { redirect_to advancements_url, notice: 'Advancement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advancement
      @advancement = Advancement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advancement_params
      params.require(:advancement).permit(:robot_code)
    end
end
