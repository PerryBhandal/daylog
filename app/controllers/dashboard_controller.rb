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
  
  def watch
    getCurrentTask
    @active_task = ActiveTask.new
    @premadeTasks = PremadeTask.all.order('name ASC')
    @historicTasks = getHistoricTasks
    setWatchTitle
    render layout: 'watch'
  end
  
  def day_review
    # Get the date from params or default to today
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
    
    # Get all task groups
    @task_groups = getTaskGroups
    
    # Find the task group for the selected date
    @selected_task_group = find_task_group_for_date(@selected_date)
    
    # Get tasks for the selected day
    if @selected_task_group
      @day_tasks = @selected_task_group.dayTasks
    else
      @day_tasks = []
    end
    
    setDayReviewTitle
  end

  protected

  def setTitle
    @title = "Dashboard"
  end
  
  def setWatchTitle
    @title = "Watch"
  end
  
  def setDayReviewTitle
    @title = "Day Review"
  end
  
  # Find the task group for a specific date
  def find_task_group_for_date(date)
    # Convert date to beginning and end of day in UTC
    start_of_day = date.beginning_of_day
    end_of_day = date.end_of_day
    
    # Find the task group that has tasks within this date range
    @task_groups.find do |task_group|
      # Check if any task in this group falls within the date range
      task_group.dayTasks.any? do |task|
        task.start_time >= start_of_day && task.start_time <= end_of_day
      end
    end
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
