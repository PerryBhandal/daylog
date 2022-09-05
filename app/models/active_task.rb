class ActiveTask < ActiveRecord::Base

  def isSleepEvent
    if task_name == "Sleep" or task_name == "**No Track"
      return true
    else
      return false
    end
  end

end
