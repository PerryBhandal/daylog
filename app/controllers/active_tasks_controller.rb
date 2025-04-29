class ActiveTasksController < ApplicationController
  before_action :set_active_task, only: [:edit, :update, :destroy]

  # GET /active_tasks
  # GET /active_tasks.json
  def index
    @active_tasks = ActiveTask.all.order('start_time DESC')
  end

  # GET /active_tasks/1/edit
  def edit
  end

  # POST /active_tasks
  # POST /active_tasks.json
  def create
    @active_task = ActiveTask.new(active_task_params)
    @active_task.start_time = DateTime.now

    respond_to do |format|
      if @active_task.save
        # Check if the request came from the watch interface
        redirect_path = params[:source] == 'watch' ? '/watch' : '/dashboard'
        format.html { redirect_to redirect_path, notice: 'Active task was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /active_tasks/1
  # PATCH/PUT /active_tasks/1.json
  def update
    respond_to do |format|
      if @active_task.update(active_task_params)
        format.html { redirect_to @active_task, notice: 'Active task was successfully updated.' }
        format.json { render :show, status: :ok, location: @active_task }
      else
        format.html { render :edit }
        format.json { render json: @active_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /active_tasks/1
  # DELETE /active_tasks/1.json
  def destroy
    @active_task.destroy
    respond_to do |format|
      format.html { redirect_to active_tasks_url, notice: 'Active task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected
  
  def setTitle
    @title = "Active Tasks"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_active_task
      @active_task = ActiveTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def active_task_params
      params.require(:active_task).permit(:task_name, :start_time)
    end
end
