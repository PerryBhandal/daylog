class DashboardController < ApplicationController
  def index
    getCurrentTask
    @active_task = ActiveTask.new
    @premadeTasks = PremadeTask.all.order('name ASC')
    @historicTasks = getHistoricTasks
    @recent_meals = getMostRecentMeals
    @recent_pills = getMostRecentPills
    @recent_exercises = getMostRecentExercises
    @recent_thoughts = getMostRecentThoughts
  end

  protected

  def setTitle
    @title = "Dashboard"
  end

  private

  def getCurrentTask
    @current_task = ActiveTask.last
  end

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
  
  # Get the most recent meals for the dashboard
  def getMostRecentMeals
    Meal.order('eaten_at DESC').limit(3)
  end
  
  # Get the most recent pills for the dashboard
  def getMostRecentPills
    Pill.order('consumed_at DESC').limit(3)
  end
  
  # Get the most recent exercises for the dashboard
  def getMostRecentExercises
    Exercise.order('exercised_at DESC').limit(3)
  end
  
  # Get the most recent thoughts for the dashboard
  def getMostRecentThoughts
    Thought.order('created_at DESC').limit(3)
  end
end
