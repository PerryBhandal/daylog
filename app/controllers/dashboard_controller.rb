class DashboardController < ApplicationController
  def index
    getCurrentTask
    @active_task = ActiveTask.new
    @premadeTasks = PremadeTask.all.order('name ASC')
    @historicTasks = getHistoricTasks
  end

  protected

  def setTitle
    @title = "Dashboard"
  end

  private

  def getCurrentTask
    @current_task = ActiveTask.last
  end

  private

  def getHistoricTasks
    taskList = []

    allTasks = ActiveTask.all.order('start_time DESC').select(:task_name).uniq()
    allTasks.each do |task|
      if PremadeTask.where(:name => task.task_name).count == 0 and !(taskList.include?(task))
        taskList.push(task)
      end
    end

    if taskList.length > 5
      taskList = taskList[0...5]
    end

    taskList
  end
end
