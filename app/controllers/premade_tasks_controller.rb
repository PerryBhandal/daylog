class PremadeTasksController < ApplicationController
  before_action :set_premade_task, only: [:show, :edit, :update, :destroy]

  # GET /premade_tasks
  # GET /premade_tasks.json
  def index
    @premade_tasks = PremadeTask.all
  end

  # GET /premade_tasks/1
  # GET /premade_tasks/1.json
  def show
  end

  # GET /premade_tasks/new
  def new
    @premade_task = PremadeTask.new
  end

  # GET /premade_tasks/1/edit
  def edit
  end

  # POST /premade_tasks
  # POST /premade_tasks.json
  def create
    @premade_task = PremadeTask.new(premade_task_params)

    respond_to do |format|
      if @premade_task.save
        format.html { redirect_to @premade_task, notice: 'Premade task was successfully created.' }
        format.json { render :show, status: :created, location: @premade_task }
      else
        format.html { render :new }
        format.json { render json: @premade_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /premade_tasks/1
  # PATCH/PUT /premade_tasks/1.json
  def update
    respond_to do |format|
      if @premade_task.update(premade_task_params)
        format.html { redirect_to @premade_task, notice: 'Premade task was successfully updated.' }
        format.json { render :show, status: :ok, location: @premade_task }
      else
        format.html { render :edit }
        format.json { render json: @premade_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /premade_tasks/1
  # DELETE /premade_tasks/1.json
  def destroy
    @premade_task.destroy
    respond_to do |format|
      format.html { redirect_to premade_tasks_url, notice: 'Premade task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_premade_task
      @premade_task = PremadeTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def premade_task_params
      params.require(:premade_task).permit(:name)
    end
end
