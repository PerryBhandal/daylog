json.array!(@exercises) do |exercise|
  json.extract! exercise, :id, :exercised_at, :exercise_type, :description, :comments
  json.url exercise_url(exercise, format: :json)
end
