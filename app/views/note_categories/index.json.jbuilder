json.array!(@note_categories) do |note_category|
  json.extract! note_category, :id, :name
  json.url note_category_url(note_category, format: :json)
end
