module ApplicationHelper

  def getNoteHTML(noteName, displayTitle, startCollapsed, includePanel=true)
    @note = Note.find_by(:title => noteName)
    if @note == nil
      "COULD NOT FIND NOTE WITH NAME #{noteName}".html_safe
    else
      if includePanel
        @title = displayTitle
        @startCollapsed = startCollapsed
        @content = @note.content
        render :partial => 'shared/note_viewer'
      else
        @note.content.html_safe
      end

    end
  end

  # Returns an array containing array elements of form 
  # [taskName:String, duration:String]. Each entry represents
  # one task group category. The array is sorted in a descending
  # format (i.e. category with the greatest time spent first).
  def getTaskBreakdown(taskGroup)
    taskCategories = {}

    # Calculate total time spent in each category
    taskGroup.dayTasks.each_index do |i|
      curTask = taskGroup.dayTasks[i]
      if i == taskGroup.dayTasks.length - 1
        # This is the last task of the day.
        taskDuration = getTaskDuration(taskGroup, curTask, nil)
      else
        # It's not the last task of the day
        taskDuration = getTaskDuration(taskGroup, curTask, taskGroup.dayTasks[i+1])
      end

      if !taskCategories[curTask.task_name]
        taskCategories[curTask.task_name] = 0
      end

      taskCategories[curTask.task_name] += taskDuration
    end

    # Sort the task categories into an array in a 
    # descending format (i.e. the first element is
    # the category which the most time was spent on).

    # Create an unsorted array of our task times
    unsortedTime = []
    taskCategories.each do |taskCategory, taskTime|
      unsortedTime.push([taskCategory, taskTime])
    end

    sortedTime = unsortedTime.sort{ |a, b| b[1] <=> a[1] }

    withTime = []
    sortedTime.each do |category|
      mins = category[1]/60;
      withTime.push([category[0],"%s:%s" % [mins/60, padTime(mins%60)]])
    end

    withTime  
  end

  # Returns the total time spent on a specific ActiveTask
  # object. 
  def getTaskDuration(taskGroup, currentTask, nextTask)
    taskDuration = nil 
    if nextTask
      taskDuration = nextTask.start_time.to_i - currentTask.start_time.to_i
    else
      if taskGroup.postSleepTask
        taskDuration = taskGroup.postSleepTask.start_time.to_i - currentTask.start_time.to_i
      else
        taskDuration = DateTime.now.to_i - currentTask.start_time.to_i
      end
    end
  end

  def renderTaskGroup(taskGroup) 
    if taskGroup == nil
      # Fresh DB.
      return
    end
    # Set Wake time
    @wakeTime = taskGroup.dayTasks[0].start_time
    if taskGroup.postSleepTask
      @sleepTime = taskGroup.postSleepTask.start_time
    else
      @sleepTime = nil
    end

    if @sleepTime
      # Day has ended
      @timeAwake = getTimeDiff(@wakeTime, taskGroup.postSleepTask.start_time)
    else
      # Day is active
      @timeAwake = getTimeDiff(@wakeTime, DateTime.now)
    end
    @taskBreakdown = getTaskBreakdown(taskGroup)
    render :partial => 'shared/task_group'
  end

  def getTimeString(dateTime)
    if dateTime
      return dateTime.to_s
    else
      return "NA"
    end
  end

  def getTimeDiff(startTime, endTime)
    secDiff = endTime.to_i - startTime.to_i
    mins = secDiff/60;
    "%s:%s" % [mins/60, padTime(mins%60)]
  end

  def padTime(toPad)
    toPad.to_s.rjust(2, '0')
  end

  class TaskGroup

    attr_accessor :preSleepTask, :postSleepTask, :dayTasks
    def initialize()
      @preSleepTask = nil
      @postSleepTask = nil 
      @dayTasks = [] 
    end

    def addTask(toAdd)
      @dayTasks.push(toAdd)
    end

    def getTimeAwake
      if @preSleepTask == nil
        # This is the first group in our system, as no sleep task precedes it. No
        # idea how long we've been up for.
        return "N/A"
      elsif @postSleepTask == nil
        # Current day, we've awoken, but haven't yet slept. Time awake is relative
        # to the current time.
        return getTimeDiff(@preSleepTask, DateTime.now)
      else
        # We've both awoken and slept.
        return getTimeDiff(@preSleepTask, @postSleepTask)
      end
    end

  end


  def getTaskGroups
    taskGroups = []
    curTaskGroup = nil

    activeTasks = ActiveTask.all

    activeTasks.each_index do |i|
      curActiveTask = activeTasks[i]
      if i == 0
        curTaskGroup = TaskGroup.new
        if curActiveTask.isSleepEvent
          curTaskGroup.preSleepTask = curActiveTask 
        else
          curTaskGroup.addTask(curActiveTask)
        end
      else
        if curActiveTask.isSleepEvent
          curTaskGroup.postSleepTask = curActiveTask
          taskGroups.push(curTaskGroup)

          if i != activeTasks.length-1
            # There are more days left
            curTaskGroup = TaskGroup.new
            curTaskGroup.preSleepTask = curActiveTask
          end
        else
          curTaskGroup.addTask(curActiveTask)
        end
      end

      if i == activeTasks.length-1
        # This is the last active task, make sure we add this task group.
        taskGroups.push(curTaskGroup)
      end
    end

    return taskGroups
  end


end
