module DashboardHelper

  def createButton(buttonText)
    %^<button type="button" class="btn btn-primary task-button">#{buttonText}</button>^.html_safe
  end
end
