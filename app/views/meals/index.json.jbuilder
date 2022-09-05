json.array!(@meals) do |meal|
  json.extract! meal, :id, :eaten_at, :meal_quality, :meal_contents, :comments
  json.url meal_url(meal, format: :json)
end
