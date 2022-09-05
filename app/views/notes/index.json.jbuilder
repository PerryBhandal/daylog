json.array!(@notes) do |note|
  json.extract! note, :id, :title, :content, :last_viewed, :total_views, :note_category_id
  json.url note_url(note, format: :json)
end
