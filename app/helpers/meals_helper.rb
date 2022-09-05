module MealsHelper

  def getMealQuality(qualityID)
    if qualityID == 0
      "Healthy"
    elsif qualityID == 1
      "Medium Healthy"
    elsif qualityID == 2
      "Low Healthy"
    elsif qualityID == 3
      "Somewhat Unhealthy"
    elsif qualityID == 4
      "Very Unhealthy"
    else
      "QUALITY NOT FOUND!"
    end
  end
end
