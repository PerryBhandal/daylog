class NoteCategoriesController < ApplicationController
  before_action :set_note_category, only: [:show, :edit, :update, :destroy]

  # GET /note_categories
  # GET /note_categories.json
  def index
    @note_categories = NoteCategory.all
  end

  # GET /note_categories/1
  # GET /note_categories/1.json
  def show
  end

  # GET /note_categories/new
  def new
    @note_category = NoteCategory.new
  end

  # GET /note_categories/1/edit
  def edit
  end

  # POST /note_categories
  # POST /note_categories.json
  def create
    @note_category = NoteCategory.new(note_category_params)

    respond_to do |format|
      if @note_category.save
        format.html { redirect_to @note_category, notice: 'Note category was successfully created.' }
        format.json { render :show, status: :created, location: @note_category }
      else
        format.html { render :new }
        format.json { render json: @note_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /note_categories/1
  # PATCH/PUT /note_categories/1.json
  def update
    respond_to do |format|
      if @note_category.update(note_category_params)
        format.html { redirect_to @note_category, notice: 'Note category was successfully updated.' }
        format.json { render :show, status: :ok, location: @note_category }
      else
        format.html { render :edit }
        format.json { render json: @note_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /note_categories/1
  # DELETE /note_categories/1.json
  def destroy
    @note_category.destroy
    respond_to do |format|
      format.html { redirect_to note_categories_url, notice: 'Note category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note_category
      @note_category = NoteCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_category_params
      params.require(:note_category).permit(:name)
    end
end
