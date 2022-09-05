class HygieneActionsController < ApplicationController
  before_action :set_hygiene_action, only: [:edit, :update, :destroy]

  # GET /hygiene_actions
  # GET /hygiene_actions.json
  def index
    @hygiene_actions = HygieneAction.all.order('action_time DESC')
  end

  # GET /hygiene_actions/new
  def new
    @hygiene_action = HygieneAction.new
  end

  # GET /hygiene_actions/1/edit
  def edit
  end

  # POST /hygiene_actions
  # POST /hygiene_actions.json
  def create
    @hygiene_action = HygieneAction.new(hygiene_action_params)

    respond_to do |format|
      if @hygiene_action.save
        format.html { redirect_to hygiene_actions_path, notice: 'Hygiene action was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /hygiene_actions/1
  # PATCH/PUT /hygiene_actions/1.json
  def update
    respond_to do |format|
      if @hygiene_action.update(hygiene_action_params)
        format.html { redirect_to hygiene_actions_path, notice: 'Hygiene action was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /hygiene_actions/1
  # DELETE /hygiene_actions/1.json
  def destroy
    @hygiene_action.destroy
    respond_to do |format|
      format.html { redirect_to hygiene_actions_url, notice: 'Hygiene action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

  def setTitle
    @title = "Hygiene"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hygiene_action
      @hygiene_action = HygieneAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hygiene_action_params
      params.require(:hygiene_action).permit(:action_time, :actions, :comments)
    end
end
