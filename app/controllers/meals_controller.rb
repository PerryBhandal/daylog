class MealsController < ApplicationController
  before_action :set_meal, only: [:edit, :update, :destroy]

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.all.order('eaten_at DESC')
  end

  # GET /meals/new
  def new
    @meal = Meal.new
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals
  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)

    respond_to do |format|
      if @meal.save
        if params[:source] == 'watch'
          format.html { redirect_to watch_path, notice: 'Meal was successfully created.' }
        else
          format.html { redirect_to meals_url, notice: 'Meal was successfully created.' }
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /meals/1
  # PATCH/PUT /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to meals_url, notice: 'Meal was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /meals/1
  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to meals_url, notice: 'Meal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

  def setTitle
    @title = "Meals"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_params
      params.require(:meal).permit(:eaten_at, :meal_quality, :meal_contents, :comments)
    end
end
