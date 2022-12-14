class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all.order('note_category_id DESC').order('last_viewed DESC')
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note.last_viewed = DateTime.now
    @note.total_views += 1
    @note.save
  end

  # GET /notes/new
  def new
    @title = "New Note"
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
    @title = "Edit Note"
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.last_viewed = DateTime.now
    @note.total_views = 0

    respond_to do |format|
      if @note.save
        format.html { redirect_to edit_note_path(@note.id), notice: 'Note was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to edit_note_path(@note.id), notice: 'Note was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

  def setTitle
    @title = "Notes"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :content, :last_viewed, :total_views, :note_category_id)
    end
end
